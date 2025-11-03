local storage = require("modules.storage")
local glossary = require("modules.glossary")
local M = { state = nil }

local TARGET_GRAMS = 40 -- threshold for completion per session
local START_WEIGHT = 0

function M.start_session(food_name)
	M.state = { food = food_name, start = socket.gettime(), start_weight = START_WEIGHT, last_weight = START_WEIGHT, eaten = 0, complete = false }
	glossary.touch(food_name) -- ensure in glossary
end

function M.on_weight_update(grams)
	if not M.state then return 0 end
	-- Positive eaten delta when weight decreases
	local delta = math.max(0, (M.state.last_weight - grams))
	M.state.last_weight = grams
	M.state.eaten = M.state.eaten + delta
	local pct = math.min(1, M.state.eaten / TARGET_GRAMS)
	if not M.state.complete and pct >= 1 then
		M.state.complete = true
		local s = storage.get_state()
		s.metrics.meals_completed = (s.metrics.meals_completed or 0) + 1
		storage.save_state(s)
		glossary.increment_exposure(M.state.food)
	end
	return pct
end

function M.is_complete()
	return M.state and M.state.complete
end

return M