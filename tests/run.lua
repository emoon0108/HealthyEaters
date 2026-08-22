package.path = "./?.lua;./?/init.lua;" .. package.path

local persisted_state

local function clone(value, seen)
	if type(value) ~= "table" then return value end
	seen = seen or {}
	if seen[value] then return seen[value] end
	local copy = {}
	seen[value] = copy
	for key, item in pairs(value) do
		copy[clone(key, seen)] = clone(item, seen)
	end
	return copy
end

sys = {
	load = function()
		return persisted_state and clone(persisted_state) or nil
	end,
	save = function(_, value)
		persisted_state = clone(value)
		return true
	end,
}

local storage = require("modules.storage")
local glossary = require("modules.glossary")
local meal = require("modules.meal")
local rewards = require("modules.rewards")
local games = require("modules.games")
local recommend = require("modules.recommend")
local shop = require("modules.shop")
local bito = require("modules.bito")
local tasks = require("modules.tasks")
local util = require("modules.util")

local passed = 0
local failed = 0

local function equal(actual, expected, message)
	if actual ~= expected then
		error(string.format("%s (expected %s, received %s)", message or "values differ", tostring(expected), tostring(actual)), 2)
	end
end

local function truthy(value, message)
	if not value then error(message or "expected a truthy value", 2) end
end

local function reset(saved)
	persisted_state = saved and clone(saved) or nil
	storage.init()
	meal.state = nil
end

local function test(name, callback)
	local ok, message = pcall(callback)
	if ok then
		passed = passed + 1
		io.write("ok - ", name, "\n")
	else
		failed = failed + 1
		io.stderr:write("not ok - ", name, "\n  ", tostring(message), "\n")
	end
end

test("storage initializes defaults and migrates partial saves", function()
	reset({ child = { name = "Avery" }, rewards = { points = 12 } })
	local state = storage.get_state()
	equal(state.child.name, "Avery", "saved child name should survive migration")
	equal(state.child.sensory_mode, "bright", "sensory mode should receive a default")
	equal(state.rewards.points, 12, "saved points should survive migration")
	equal(state.rewards.tokens, 0, "missing tokens should receive a default")
	truthy(state.inventory.equipped, "inventory defaults should be populated")
end)

test("meal progress rewards distinct exposure steps exactly once", function()
	reset()
	glossary.ensure_defaults()
	meal.start_session("Apple")
	truthy(meal.mark_look(), "look step should be recorded")
	local progress, events = meal.on_weight_update(200)
	equal(progress, 0, "the calibration reading should not count as food eaten")
	equal(events[1], "interact", "the first plate reading should record interaction")
	progress, events = meal.on_weight_update(194)
	truthy(progress > 0, "a weight decrease should advance progress")
	equal(events[1], "taste", "five grams should record the taste step")
	progress, events = meal.on_weight_update(160)
	equal(progress, 1, "forty grams should complete the challenge")
	equal(events[1], "complete", "completion should emit once")
	equal(storage.get_state().metrics.meals_completed, 1, "completion metric should increment once")
	meal.on_weight_update(150)
	equal(storage.get_state().metrics.meals_completed, 1, "later readings must not double count completion")
	equal(glossary.all()[1].exposures, 1, "food exposure should increment once")
end)

test("reward balances, streaks, levels, and badges remain consistent", function()
	reset()
	local state = storage.get_state()
	state.metrics.meals_completed = 10
	state.metrics.new_foods = 3
	storage.save_state(state)
	rewards.award_points(100, { reason = "meal_complete" })
	equal(rewards.get_points(), 100, "points should be awarded")
	equal(rewards.level(), 2, "one hundred points should reach level two")
	equal(storage.get_state().rewards.streak, 1, "meal rewards should advance the streak")
	truthy(storage.get_state().rewards.badges.meal10, "meal badge should unlock")
	truthy(storage.get_state().rewards.badges.new3, "food explorer badge should unlock")
	truthy(not rewards.spend_points(101), "overspending points should fail")
	truthy(rewards.spend_points(25), "affordable point spend should succeed")
	equal(rewards.get_points(), 75, "point spend should persist")
end)

test("game sessions enforce token cost and idempotent completion", function()
	reset()
	rewards.award_tokens(1)
	local session, message = games.start_session("food_match")
	truthy(session, message or "the funded game should start")
	equal(rewards.get_tokens(), 0, "starting a game should spend its token")
	local blocked, reason = games.start_session("food_match")
	equal(blocked, nil, "a second game should be blocked without tokens")
	equal(reason, "not_enough_tokens", "the token error should be explicit")
	equal(games.complete_session(session, 8), 15, "completion should award the configured points")
	equal(games.complete_session(session, 10), 0, "the same session must not pay twice")
	equal(rewards.get_points(), 15, "game points should persist")
end)

test("shop purchases require funds and only owned equippable items can be equipped", function()
	reset()
	local ok, reason = shop.buy("bito_scout_polish")
	equal(ok, false, "an unfunded purchase should fail")
	equal(reason, "not_enough_points", "the purchase error should be explicit")
	rewards.award_points(25)
	ok = shop.buy("bito_scout_polish")
	truthy(ok, "an affordable purchase should succeed")
	equal(rewards.get_points(), 0, "purchase cost should be deducted")
	ok, reason = shop.buy("bito_scout_polish")
	equal(ok, false, "duplicate purchases should fail")
	equal(reason, "already_owned", "duplicate purchase should be identified")
	ok = shop.equip("bito_scout_polish")
	truthy(ok, "an owned cosmetic should equip")
	equal(storage.get_state().inventory.equipped.bito_core, "bito_scout_polish", "equipped item should persist")
end)

test("recommendations favor low-exposure foods and diversify food groups", function()
	reset()
	glossary.ensure_defaults()
	for _ = 1, 3 do glossary.increment_exposure("Apple", "complete") end
	local recommendations = recommend.next_meal_recs(3)
	equal(#recommendations, 3, "three recommendations should be returned")
	truthy(recommendations[1] ~= "Apple", "the most exposed food should not rank first")
	local seen = {}
	for _, name in ipairs(recommendations) do
		local group
		for _, food in ipairs(glossary.all()) do
			if food.name == name then group = food.group end
		end
		truthy(not seen[group], "recommendations should diversify food groups")
		seen[group] = true
	end
end)

test("Bito progression carries experience and clamps energy", function()
	reset()
	local state, leveled_up = bito.add_exp(200)
	truthy(leveled_up, "experience should trigger a level up")
	equal(state.level, 3, "experience should carry across multiple levels")
	equal(state.exp, 75, "remaining experience should be retained")
	equal(bito.set_energy(140), 100, "energy should clamp at one hundred")
	equal(bito.add_energy(-150), 0, "energy should clamp at zero")
	equal(bito.get_status(), "low_power", "zero energy should use the low-power state")
end)

test("missions complete, claim once, and expose progress copy", function()
	reset()
	local completed = tasks.check_task_progress("grams_eaten", 40)
	equal(#completed, 1, "the matching mission should complete")
	equal(completed[1].status, "completed", "completed mission should be claimable")
	local ok, mission = tasks.claim("first_bites")
	truthy(ok, "completed mission should claim")
	equal(mission.reward_points, 15, "claim should expose configured reward")
	ok = tasks.claim("first_bites")
	equal(ok, false, "claimed mission should not claim twice")
end)

test("utility clamp handles both bounds", function()
	equal(util.clamp(-2, 0, 10), 0, "lower bound should clamp")
	equal(util.clamp(14, 0, 10), 10, "upper bound should clamp")
	equal(util.clamp(6, 0, 10), 6, "in-range value should be unchanged")
end)

io.write(string.format("\n%d passed, %d failed\n", passed, failed))
if failed > 0 then os.exit(1) end
