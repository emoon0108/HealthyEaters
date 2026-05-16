local storage = require("modules.storage")
local rewards = require("modules.rewards")
local M = {}

local EQUIPPABLE = {
	buddy = true,
	bito_core = true,
	bito_armor = true,
	bito_trail = true,
	plate = true,
	celebration = true,
	title = true,
}

local ITEMS = {
	{ id = "bito_scout_polish", name = "Scout Polish", category = "bito_core", cost = 25, desc = "Gives Bito a shiny starter shell for mission days." },
	{ id = "bito_rainbow_circuit", name = "Rainbow Circuit", category = "bito_core", cost = 55, desc = "Adds a colorful circuit glow to Bito's core." },
	{ id = "bito_garden_armor", name = "Garden Armor", category = "bito_armor", cost = 70, desc = "Leafy armor plates for brave food exploring." },
	{ id = "bito_star_visor", name = "Star Visor", category = "bito_armor", cost = 45, desc = "A bright visor for spotting new food missions." },
	{ id = "bito_spark_trail", name = "Spark Trail", category = "bito_trail", cost = 35, desc = "A tiny sparkle trail for Bito's happy dance." },
	{ id = "bito_calm_glow", name = "Calm Glow", category = "bito_trail", cost = 35, desc = "A soft glow effect for low-stim celebrations." },
	{ id = "buddy_chef_hat", name = "Chef Hat", category = "buddy", cost = 30, desc = "A tiny chef hat for the food buddy." },
	{ id = "buddy_rainbow_apron", name = "Rainbow Apron", category = "buddy", cost = 40, desc = "A colorful apron for trying rainbow foods." },
	{ id = "buddy_star_glasses", name = "Star Glasses", category = "buddy", cost = 35, desc = "Bright glasses for a curious food explorer." },
	{ id = "plate_sunshine", name = "Sunshine Plate", category = "plate", cost = 45, desc = "A warm yellow plate theme." },
	{ id = "plate_garden", name = "Garden Plate", category = "plate", cost = 45, desc = "A green garden plate theme." },
	{ id = "plate_rainbow", name = "Rainbow Plate", category = "plate", cost = 60, desc = "A plate theme with every food color." },
	{ id = "fact_carrot", name = "Carrot Fact Card", category = "food_fact", cost = 20, desc = "Unlock a friendly fact about carrots and eye health." },
	{ id = "fact_yogurt", name = "Yogurt Fact Card", category = "food_fact", cost = 20, desc = "Unlock a friendly fact about yogurt and strong bones." },
	{ id = "garden_seed_apple", name = "Apple Seed", category = "garden", cost = 25, desc = "Plant an apple seed in the virtual garden." },
	{ id = "garden_seed_carrot", name = "Carrot Seed", category = "garden", cost = 25, desc = "Plant a carrot seed in the virtual garden." },
	{ id = "title_taste_explorer", name = "Taste Explorer", category = "title", cost = 50, desc = "A profile title for trying new foods." },
	{ id = "title_rainbow_builder", name = "Rainbow Builder", category = "title", cost = 50, desc = "A profile title for colorful plates." },
	{ id = "celebration_confetti", name = "Confetti Celebration", category = "celebration", cost = 35, desc = "A cheerful completion animation." },
	{ id = "celebration_stars", name = "Star Celebration", category = "celebration", cost = 35, desc = "A calm starry completion animation." },
}

local function state()
	local s = storage.get_state()
	if not s then
		storage.init()
		s = storage.get_state()
	end
	s.inventory = s.inventory or { items = {}, equipped = {} }
	s.inventory.items = s.inventory.items or {}
	s.inventory.equipped = s.inventory.equipped or {}
	return s
end

function M.all()
	return ITEMS
end

function M.get(id)
	for _, item in ipairs(ITEMS) do
		if item.id == id then
			return item
		end
	end
	return nil
end

function M.owned(id)
	local s = state()
	return s.inventory.items[id] == true
end

function M.buy(id)
	local item = M.get(id)
	if not item then
		return false, "unknown_item"
	end
	if M.owned(id) then
		return false, "already_owned"
	end
	if not rewards.spend_points(item.cost) then
		return false, "not_enough_points"
	end
	local s = state()
	s.inventory.items[id] = true
	storage.save_state(s)
	return true, item
end

function M.equip(id)
	local item = M.get(id)
	if not item then
		return false, "unknown_item"
	end
	if not M.owned(id) then
		return false, "not_owned"
	end
	local s = state()
	if not EQUIPPABLE[item.category] then
		return false, "not_equipable"
	end
	s.inventory.equipped[item.category] = id
	storage.save_state(s)
	return true, item
end

return M
