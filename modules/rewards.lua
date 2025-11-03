local storage = require("modules.storage")
local M = {}

local BADGES = {
	meal10 = { id="meal10", name="Taster", desc="10 meals completed", cond=function(s) return (s.metrics.meals_completed or 0) >= 10 end },
	new3 = { id="new3", name="Explorer", desc="Tried 3 new foods", cond=function(s) return (s.metrics.new_foods or 0) >= 3 end },
}

function M.get_points()
	return storage.get_state().rewards.points or 0
end

function M.award_points(pts, opts)
	local s = storage.get_state()
	s.rewards.points = (s.rewards.points or 0) + pts
	if opts and opts.reason == "meal_complete" then
		-- streak logic (simplified)
		s.rewards.streak = (s.rewards.streak or 0) + 1
	end
	-- badge check
	for _, b in pairs(BADGES) do
		if not s.rewards.badges[b.id] and b.cond(s) then s.rewards.badges[b.id] = true end
	end
	storage.save_state(s)
end

function M.level()
	local p = M.get_points()
	return 1 + math.floor(p / 100)
end

return M