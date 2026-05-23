local M = {}

local KEY = "healthy_eaters_state"
local _state

local function defaults()
	return {
		child = { name = "Player", sensory_mode = "bright", sensitivities = { texture = false, smell = false, color = false } },
		glossary = {},
		rewards = { points = 0, tokens = 0, streak = 0, badges = {} },
		inventory = { items = {}, equipped = { buddy = nil, plate = nil, celebration = nil, title = nil } },
		metrics = { meals_completed = 0, new_foods = 0 },
		ops = {
			session_code = "HE-1042",
			status = "planned",
			active_food = nil,
			event_log = {},
			menu = {
				{ name = "Apple", available = true, window = "Anytime", closed = false },
				{ name = "Carrot", available = true, window = "Lunch", closed = false },
				{ name = "Yogurt", available = true, window = "Breakfast", closed = false },
				{ name = "Rice", available = true, window = "Dinner", closed = false },
				{ name = "Chicken", available = true, window = "Dinner", closed = false },
			},
			stock = {
				Apple = 4,
				Carrot = 3,
				Yogurt = 2,
				Rice = 5,
				Chicken = 2,
			},
		},
		bito = { level = 1, exp = 0, energy_level = 50, current_form = "Scout" },
		tasks = { missions = nil },
	}
end

function M.init()
	local d = defaults()
	_state = sys.load(KEY) or d
	_state.child = _state.child or d.child
	_state.child.sensory_mode = _state.child.sensory_mode or d.child.sensory_mode
	_state.child.sensitivities = _state.child.sensitivities or d.child.sensitivities
	_state.glossary = _state.glossary or {}
	_state.rewards = _state.rewards or d.rewards
	_state.rewards.points = _state.rewards.points or 0
	_state.rewards.tokens = _state.rewards.tokens or 0
	_state.rewards.streak = _state.rewards.streak or 0
	_state.rewards.badges = _state.rewards.badges or {}
	_state.inventory = _state.inventory or d.inventory
	_state.inventory.items = _state.inventory.items or {}
	_state.inventory.equipped = _state.inventory.equipped or d.inventory.equipped
	_state.metrics = _state.metrics or d.metrics
	_state.ops = _state.ops or d.ops
	_state.ops.session_code = _state.ops.session_code or d.ops.session_code
	_state.ops.status = _state.ops.status or d.ops.status
	_state.ops.event_log = _state.ops.event_log or {}
	_state.ops.menu = _state.ops.menu or d.ops.menu
	_state.ops.stock = _state.ops.stock or d.ops.stock
	_state.bito = _state.bito or d.bito
	_state.bito.level = _state.bito.level or d.bito.level
	_state.bito.exp = _state.bito.exp or d.bito.exp
	_state.bito.energy_level = _state.bito.energy_level or d.bito.energy_level
	_state.bito.current_form = _state.bito.current_form or d.bito.current_form
	_state.tasks = _state.tasks or d.tasks
	sys.save(KEY, _state)
end

function M.get_state()
	return _state
end

function M.save_state(s)
	_state = s
	sys.save(KEY, _state)
end

-- Firebase-ready stubs (use a native extension or HTTP endpoint when available)
function M.push_meal(meal)
	-- POST to your backend when implemented
end

return M
