local M = {}

local KEY = "healthy_eaters_state"
local _state

local function defaults()
	return {
		child = { name = "Player", sensitivities = { texture = false, smell = false, color = false } },
		glossary = {},
		rewards = { points = 0, tokens = 0, streak = 0, badges = {} },
		inventory = { items = {}, equipped = { buddy = nil, plate = nil, celebration = nil, title = nil } },
		metrics = { meals_completed = 0, new_foods = 0 },
	}
end

function M.init()
	local d = defaults()
	_state = sys.load(KEY) or d
	_state.child = _state.child or d.child
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
	sys.save(KEY, _state)
	local glossary = require("modules.glossary")
	glossary.ensure_defaults()
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
