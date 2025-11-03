local storage = require("modules.storage")
local M = {}

-- Simple heuristic: suggest foods with the fewest exposures, diversified by food group
function M.next_meal_recs(n)
	local s = storage.get_state()
	local foods = s.glossary
	table.sort(foods, function(a,b)
		return (a.exposures or 0) < (b.exposures or 0)
	end)
	local recs = {}
	local seen_group = {}
	for _, f in ipairs(foods) do
		if not seen_group[f.group or "?"] then
			table.insert(recs, f.name)
			seen_group[f.group or "?"] = true
			if #recs >= (n or 3) then break end
		end
	end
	return recs
end

-- Hook: replace with cloud/edge model later
function M.ai_personalize(context)
	-- context: { age, sensitivities, history, nutrient_gaps }
	-- return ranked list of foods or challenges
	return M.next_meal_recs(3)
end

return M