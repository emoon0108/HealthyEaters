local storage = require("modules.storage")
local M = {}

local STATUSES = {
	planned = "Planned",
	started = "Started",
	tasting = "Tasting",
	completed = "Completed",
	reviewed = "Reviewed",
}

local STATUS_ORDER = { "planned", "started", "tasting", "completed", "reviewed" }

local function clock_label()
	local t = os.date("*t")
	return string.format("%02d:%02d", t.hour, t.min)
end

local function ensure_ops()
	local s = storage.get_state()
	s.ops = s.ops or {}
	s.ops.session_code = s.ops.session_code or "HE-1042"
	s.ops.status = s.ops.status or "planned"
	s.ops.event_log = s.ops.event_log or {}
	s.ops.menu = s.ops.menu or {}
	s.ops.stock = s.ops.stock or {}
	storage.save_state(s)
	return s.ops
end

function M.log(event)
	local s = storage.get_state()
	local ops = ensure_ops()
	table.insert(ops.event_log, 1, clock_label() .. "  " .. event)
	while #ops.event_log > 8 do
		table.remove(ops.event_log)
	end
	s.ops = ops
	storage.save_state(s)
end

function M.new_session_code()
	local s = storage.get_state()
	local ops = ensure_ops()
	local seed = math.floor((os.time() % 9000) + 1000)
	ops.session_code = "HE-" .. seed
	ops.status = "planned"
	ops.active_food = nil
	s.ops = ops
	storage.save_state(s)
	M.log("New QR meal session code created: " .. ops.session_code)
	return ops.session_code
end

function M.set_status(status, food)
	local s = storage.get_state()
	local ops = ensure_ops()
	ops.status = status
	ops.active_food = food or ops.active_food
	s.ops = ops
	storage.save_state(s)
	M.log("Meal pipeline moved to " .. (STATUSES[status] or status) .. (food and (" for " .. food) or ""))
end

function M.consume_stock(food)
	local s = storage.get_state()
	local ops = ensure_ops()
	ops.stock[food] = math.max(0, (ops.stock[food] or 0) - 1)
	s.ops = ops
	storage.save_state(s)
	M.log("Inventory used 1 " .. food .. ". Stock now " .. ops.stock[food])
end

function M.restock_low()
	local s = storage.get_state()
	local ops = ensure_ops()
	for _, item in ipairs(ops.menu or {}) do
		local food = item.name
		if (ops.stock[food] or 0) < 2 then
			ops.stock[food] = 4
		end
	end
	s.ops = ops
	storage.save_state(s)
	M.log("Low-stock foods restocked from supply list")
end

function M.toggle_menu_food(food)
	local s = storage.get_state()
	local ops = ensure_ops()
	for _, item in ipairs(ops.menu or {}) do
		if item.name == food then
			item.available = not item.available
			M.log(food .. " marked " .. (item.available and "available" or "paused") .. " on the challenge menu")
			s.ops = ops
			storage.save_state(s)
			return item.available
		end
	end
	return false
end

function M.is_food_available(food)
	local ops = ensure_ops()
	for _, item in ipairs(ops.menu or {}) do
		if item.name == food then
			return item.available and not item.closed and (ops.stock[food] or 0) > 0
		end
	end
	return true
end

function M.summary()
	local ops = ensure_ops()
	local stock_low = {}
	local menu_lines = {}
	for _, item in ipairs(ops.menu or {}) do
		local food = item.name
		local stock = ops.stock[food] or 0
		local state = item.available and "open" or "paused"
		if stock <= 1 then
			stock_low[#stock_low + 1] = food
		end
		menu_lines[#menu_lines + 1] = food .. ": " .. state .. ", stock " .. stock .. ", " .. (item.window or "Anytime")
	end
	return {
		code = ops.session_code,
		status = STATUSES[ops.status] or ops.status,
		active_food = ops.active_food or "none",
		menu = table.concat(menu_lines, "\n"),
		stock_alert = #stock_low > 0 and table.concat(stock_low, ", ") or "none",
		events = table.concat(ops.event_log or {}, "\n"),
	}
end

function M.pipeline_text()
	local ops = ensure_ops()
	local parts = {}
	for _, status in ipairs(STATUS_ORDER) do
		parts[#parts + 1] = (status == ops.status and "[" .. STATUSES[status] .. "]" or STATUSES[status])
	end
	return table.concat(parts, " > ")
end

return M
