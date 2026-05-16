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
		local sensory_ok = true
		if s.child and s.child.sensitivities then
			if s.child.sensitivities.texture and f.texture == "Chewy" then sensory_ok = false end
			if s.child.sensitivities.smell and f.smell and f.smell ~= "Mild" then sensory_ok = false end
			if s.child.sensitivities.color and f.color and f.color ~= "White" and f.color ~= "Beige" then sensory_ok = false end
		end
		if sensory_ok and not seen_group[f.group or "?"] then
			table.insert(recs, f.name)
			seen_group[f.group or "?"] = true
			if #recs >= (n or 3) then break end
		end
	end
	return recs
end

function M.attribute_summary()
	local s = storage.get_state()
	local totals = { texture = {}, color = {} }
	for _, f in ipairs(s.glossary or {}) do
		local completed = f.steps and (f.steps.complete or 0) or 0
		if completed > 0 then
			totals.texture[f.texture or "Unknown"] = (totals.texture[f.texture or "Unknown"] or 0) + completed
			totals.color[f.color or "Unknown"] = (totals.color[f.color or "Unknown"] or 0) + completed
		end
	end
	return totals
end

-- Hook: replace with cloud/edge model later
function M.ai_personalize(context)
	-- context: { age, sensitivities, history, nutrient_gaps }
	-- return ranked list of foods or challenges
	return M.next_meal_recs(3)
end

return M
