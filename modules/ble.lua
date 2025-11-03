-- Platform-agnostic Lua API. Implement the native side via a Defold Native Extension
-- that talks to CoreBluetooth (iOS) / Android BLE. For now, we simulate data.
local M = { cb = nil, connected = false }

local function simulate()
	-- Simulate decreasing plate weight over time
	local grams = 200
	local function tick()
		if not M.connected then return end
		grams = math.max(0, grams - math.random(3,8))
		if M.cb and M.cb.on_weight then M.cb.on_weight(grams) end
		if grams > 0 then timer.delay(0.5, false, tick) end
	end
	timer.delay(1.0, false, tick)
end

function M.init(callbacks)
	M.cb = callbacks or {}
	M.connected = true
	if M.cb.on_connected then M.cb.on_connected() end
	simulate()
end

function M.disconnect()
	M.connected = false
	if M.cb and M.cb.on_disconnected then M.cb.on_disconnected() end
end

return M