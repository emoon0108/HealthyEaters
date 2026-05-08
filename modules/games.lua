local rewards = require("modules.rewards")
local M = {}

local GAMES = {
	{
		id = "food_match",
		name = "Food Match",
		cost = 1,
		point_reward = 10,
		duration = 45,
		type = "matching",
		desc = "Match each food to its group.",
		foods = {
			{ name = "Apple", answer = "Fruits" },
			{ name = "Carrot", answer = "Vegetables" },
			{ name = "Yogurt", answer = "Dairy" },
			{ name = "Rice", answer = "Grains" },
			{ name = "Chicken", answer = "Protein" },
		},
	},
	{
		id = "garden_catch",
		name = "Garden Catch",
		cost = 1,
		point_reward = 10,
		duration = 45,
		type = "catch",
		desc = "Catch falling fruits and vegetables in a basket.",
		foods = { "Apple", "Strawberry", "Carrot", "Broccoli", "Tomato", "Blueberry" },
		avoid = { "Candy", "Soda" },
	},
	{
		id = "plate_builder",
		name = "Plate Builder",
		cost = 2,
		point_reward = 20,
		duration = 60,
		type = "drag",
		desc = "Build a balanced plate with foods from different groups.",
		plate = {
			{ group = "Fruits", choices = { "Apple", "Banana", "Orange" } },
			{ group = "Vegetables", choices = { "Carrot", "Broccoli", "Peas" } },
			{ group = "Grains", choices = { "Rice", "Bread", "Pasta" } },
			{ group = "Protein", choices = { "Chicken", "Egg", "Beans" } },
			{ group = "Dairy", choices = { "Yogurt", "Milk", "Cheese" } },
		},
	},
	{
		id = "texture_sort",
		name = "Texture Sort",
		cost = 1,
		point_reward = 10,
		duration = 45,
		type = "sorting",
		desc = "Sort foods by texture: crunchy, soft, smooth, or chewy.",
		foods = {
			{ name = "Carrot", answer = "Crunchy" },
			{ name = "Banana", answer = "Soft" },
			{ name = "Yogurt", answer = "Smooth" },
			{ name = "Chicken", answer = "Chewy" },
		},
	},
	{
		id = "color_plate",
		name = "Color Plate",
		cost = 1,
		point_reward = 10,
		duration = 45,
		type = "collection",
		desc = "Fill the plate with foods of every color.",
		foods = {
			{ name = "Tomato", color = "Red" },
			{ name = "Carrot", color = "Orange" },
			{ name = "Corn", color = "Yellow" },
			{ name = "Broccoli", color = "Green" },
			{ name = "Blueberry", color = "Blue" },
			{ name = "Eggplant", color = "Purple" },
		},
	},
	{
		id = "memory_meal",
		name = "Memory Meal",
		cost = 1,
		point_reward = 15,
		duration = 60,
		type = "memory",
		desc = "Flip cards and match healthy food pairs.",
		pairs = { "Apple", "Carrot", "Yogurt", "Rice", "Chicken", "Broccoli" },
	},
	{
		id = "food_maze",
		name = "Food Maze",
		cost = 2,
		point_reward = 20,
		duration = 60,
		type = "maze",
		desc = "Move through a maze to collect healthy meal ingredients.",
		goal = "Collect Apple, Carrot, Rice, and Chicken before reaching the plate.",
		foods = { "Apple", "Carrot", "Rice", "Chicken" },
	},
	{
		id = "snack_tap",
		name = "Snack Tap",
		cost = 1,
		point_reward = 10,
		duration = 30,
		type = "tap",
		desc = "Tap healthy snacks as they appear and skip sugary snacks.",
		foods = { "Apple Slice", "Carrot Stick", "Yogurt Cup", "Cheese Cube", "Cucumber Slice" },
		avoid = { "Cookie", "Candy", "Soda" },
	},
	{
		id = "recipe_order",
		name = "Recipe Order",
		cost = 2,
		point_reward = 20,
		duration = 60,
		type = "sequence",
		desc = "Put simple healthy recipe steps in the right order.",
		recipes = {
			{ name = "Fruit Bowl", steps = { "Wash fruit", "Slice fruit", "Mix in bowl", "Eat" } },
			{ name = "Yogurt Parfait", steps = { "Add yogurt", "Add berries", "Add granola", "Take a bite" } },
			{ name = "Rice Bowl", steps = { "Add rice", "Add protein", "Add vegetables", "Mix" } },
		},
	},
	{
		id = "nutrient_quest",
		name = "Nutrient Quest",
		cost = 3,
		point_reward = 30,
		duration = 60,
		type = "quest",
		desc = "Collect foods that give helpful body powers.",
		powers = {
			{ food = "Carrot", power = "Eye Power" },
			{ food = "Milk", power = "Bone Power" },
			{ food = "Beans", power = "Muscle Power" },
			{ food = "Orange", power = "Shield Power" },
			{ food = "Oatmeal", power = "Energy Power" },
		},
	},
}

function M.all()
	return GAMES
end

function M.get(id)
	for _, game in ipairs(GAMES) do
		if game.id == id then
			return game
		end
	end
	return nil
end

function M.can_play(id)
	local game = M.get(id)
	return game ~= nil and rewards.get_tokens() >= game.cost
end

function M.unlock_play(id)
	local game = M.get(id)
	if not game then
		return false, "unknown_game"
	end
	if not rewards.spend_tokens(game.cost) then
		return false, "not_enough_tokens"
	end
	return true, game
end

function M.start_session(id)
	local ok, result = M.unlock_play(id)
	if not ok then
		return nil, result
	end
	return {
		game = result,
		score = 0,
		remaining = result.duration,
		complete = false,
	}
end

function M.complete_session(session, score)
	if not session or not session.game or session.complete then
		return 0
	end
	session.score = score or session.score or 0
	session.complete = true
	local earned = session.game.point_reward or 0
	rewards.award_points(earned, { reason = "game_complete", game_id = session.game.id })
	return earned
end

return M
