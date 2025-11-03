local json = require("djson") -- if unavailable, switch to built-in sys.save tables only
local M = {}

local KEY = "healthy_eaters_state"
local _state

local function defaults()
	return {
		child = { name = "Player", sensitivities = { texture = false, smell = false, color = false } },
		glossary = {},
		rewards = { points = 0, streak = 0, badges = {} },
		metrics = { meals_completed = 0, new_foods = 0 },
	}
end

function M.init()
	_state = sys.load(KEY) or defaults()
	-- backward compat / fill
	_state.rewards.badges = _state.rewards.badges or {}
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