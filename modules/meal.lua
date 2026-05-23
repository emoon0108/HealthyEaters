local storage = require("modules.storage")
local glossary = require("modules.glossary")
local M = { state = nil }

local TARGET_GRAMS = 40 -- threshold for completion per session
local TASTE_GRAMS = 5

local function now()
	if socket and socket.gettime then
		return socket.gettime()
	end
	return os.time()
end

function M.start_session(food_name)
	M.state = {
		food = food_name,
		start = now(),
		start_weight = nil,
		last_weight = nil,
		eaten = 0,
		complete = false,
		status = "planned",
		steps = { look = false, interact = false, taste = false, complete = false },
	}
	glossary.touch(food_name) -- ensure in glossary
end

function M.on_weight_update(grams)
	if not M.state then return 0, {} end
	local events = {}
	if not M.state.last_weight then
		M.state.start_weight = grams
		M.state.last_weight = grams
		if not M.state.steps.interact then
			M.state.steps.interact = true
			M.state.status = "started"
			table.insert(events, "interact")
			glossary.record_step(M.state.food, "interact")
		end
		return 0, events
	end
	-- Positive eaten delta when weight decreases
	local delta = math.max(0, (M.state.last_weight - grams))
	M.state.last_weight = grams
	M.state.eaten = M.state.eaten + delta
	local pct = math.min(1, M.state.eaten / TARGET_GRAMS)
	if not M.state.steps.taste and M.state.eaten >= TASTE_GRAMS then
		M.state.steps.taste = true
		M.state.status = "tasting"
		table.insert(events, "taste")
		glossary.record_step(M.state.food, "taste")
	end
	if not M.state.complete and pct >= 1 then
		M.state.complete = true
		M.state.status = "completed"
		M.state.steps.complete = true
		table.insert(events, "complete")
		local s = storage.get_state()
		s.metrics.meals_completed = (s.metrics.meals_completed or 0) + 1
		storage.save_state(s)
		glossary.increment_exposure(M.state.food, "complete")
	end
	return pct, events
end

function M.is_complete()
	return M.state and M.state.complete
end

function M.mark_look()
	if not M.state or M.state.steps.look then
		return false
	end
	M.state.steps.look = true
	glossary.record_step(M.state.food, "look")
	return true
end

function M.step_status()
	return M.state and M.state.steps or {}
end

return M
