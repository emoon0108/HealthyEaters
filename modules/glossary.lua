local storage = require("modules.storage")
local M = {}

local DEFAULTS = {
	{ name="Apple", group="Fruits" },
	{ name="Carrot", group="Vegetables" },
	{ name="Yogurt", group="Dairy" },
	{ name="Rice", group="Grain" },
	{ name="Chicken", group="Protein" },
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
		table.insert(s.glossary, { name=name, exposures=0 })
		s.metrics.new_foods = (s.metrics.new_foods or 0) + 1
		storage.save_state(s)
	end
end

function M.increment_exposure(name)
	local s = storage.get_state()
	for _, f in ipairs(s.glossary) do
		if f.name == name then f.exposures = (f.exposures or 0) + 1 end
	end
	storage.save_state(s)
end

function M.ensure_defaults()
	local s = storage.get_state()
	if #s.glossary == 0 then
		for _, f in ipairs(DEFAULTS) do table.insert(s.glossary, { name=f.name, group=f.group, exposures=0 }) end
		storage.save_state(s)
	end
end

return M