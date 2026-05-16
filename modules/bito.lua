local storage = require("modules.storage")

local M = {}

local FORMS = {
	{ min_level = 1, max_level = 5, name = "Scout" },
	{ min_level = 6, max_level = 10, name = "Technician" },
	{ min_level = 11, max_level = math.huge, name = "Explorer" },
}

local function clamp(value, min_value, max_value)
	return math.max(min_value, math.min(max_value, value))
end

local function state()
	local s = storage.get_state()
	if not s then
		storage.init()
		s = storage.get_state()
	end
	s.bito = s.bito or { level = 1, exp = 0, energy_level = 50, current_form = "Scout" }
	return s.bito, s
end

local function form_for_level(level)
	for _, form in ipairs(FORMS) do
		if level >= form.min_level and level <= form.max_level then
			return form.name
		end
	end
	return "Scout"
end

function M.exp_required(level)
	return 50 + ((level - 1) * 25)
end

function M.sync_form()
	local bito, s = state()
	bito.current_form = form_for_level(bito.level or 1)
	storage.save_state(s)
	return bito.current_form
end

function M.get_state()
	local bito = state()
	return bito
end

function M.add_exp(amount)
	local bito, s = state()
	local leveled_up = false
	bito.exp = (bito.exp or 0) + math.max(0, amount or 0)
	bito.level = bito.level or 1

	while bito.exp >= M.exp_required(bito.level) do
		bito.exp = bito.exp - M.exp_required(bito.level)
		bito.level = bito.level + 1
		leveled_up = true
	end

	bito.current_form = form_for_level(bito.level)
	storage.save_state(s)
	return bito, leveled_up
end

function M.add_energy(amount)
	local bito, s = state()
	bito.energy_level = clamp((bito.energy_level or 0) + (amount or 0), 0, 100)
	storage.save_state(s)
	return bito.energy_level
end

function M.set_energy(value)
	local bito, s = state()
	bito.energy_level = clamp(value or 0, 0, 100)
	storage.save_state(s)
	return bito.energy_level
end

function M.get_status()
	local bito = state()
	local energy = bito.energy_level or 0
	if energy < 20 then
		return "low_power"
	end
	return "idle"
end

function M.animation_for_form()
	local bito = state()
	local form = bito.current_form or form_for_level(bito.level or 1)
	return string.lower(form) .. "_" .. M.get_status()
end

return M
