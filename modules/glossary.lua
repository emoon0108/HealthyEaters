local storage = require("modules.storage")
local M = {}

local DEFAULTS = {
	{ name="Apple", group="Fruits", texture="Crunchy", color="Red", smell="Mild", temperature="Cool" },
	{ name="Carrot", group="Vegetables", texture="Crunchy", color="Orange", smell="Mild", temperature="Cool" },
	{ name="Yogurt", group="Dairy", texture="Smooth", color="White", smell="Tangy", temperature="Cold" },
	{ name="Rice", group="Grains", texture="Soft", color="White", smell="Mild", temperature="Warm" },
	{ name="Chicken", group="Protein", texture="Chewy", color="Beige", smell="Savory", temperature="Warm" },
}

local function index_by_name(list)
	local map = {}
	for i, f in ipairs(list) do map[f.name] = i end
	return map
end

function M.all()
	return storage.get_state().glossary
end

function M.touch(name)
	local s = storage.get_state()
	local map = index_by_name(s.glossary)
	if not map[name] then
		table.insert(s.glossary, { name=name, group="Unknown", texture="Unknown", color="Unknown", smell="Unknown", temperature="Unknown", exposures=0, steps={} })
		s.metrics.new_foods = (s.metrics.new_foods or 0) + 1
		storage.save_state(s)
	end
end

function M.increment_exposure(name, step)
	local s = storage.get_state()
	for _, f in ipairs(s.glossary) do
		if f.name == name then f.exposures = (f.exposures or 0) + 1 end
		if f.name == name and step then
			f.steps = f.steps or {}
			f.steps[step] = (f.steps[step] or 0) + 1
		end
	end
	storage.save_state(s)
end

function M.record_step(name, step)
	local s = storage.get_state()
	for _, f in ipairs(s.glossary) do
		if f.name == name then
			f.steps = f.steps or {}
			f.steps[step] = (f.steps[step] or 0) + 1
		end
	end
	storage.save_state(s)
end

function M.ensure_defaults()
	local s = storage.get_state()
	if #s.glossary == 0 then
		for _, f in ipairs(DEFAULTS) do
			table.insert(s.glossary, {
				name = f.name,
				group = f.group,
				texture = f.texture,
				color = f.color,
				smell = f.smell,
				temperature = f.temperature,
				exposures = 0,
				steps = {},
			})
		end
		storage.save_state(s)
	end
	local map = index_by_name(s.glossary)
	for _, default in ipairs(DEFAULTS) do
		local existing = map[default.name] and s.glossary[map[default.name]]
		if existing then
			existing.group = existing.group or default.group
			existing.texture = existing.texture or default.texture
			existing.color = existing.color or default.color
			existing.smell = existing.smell or default.smell
			existing.temperature = existing.temperature or default.temperature
			existing.steps = existing.steps or {}
		end
	end
	storage.save_state(s)
end

return M
