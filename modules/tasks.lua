local storage = require("modules.storage")

local M = {}

local DEFAULT_MISSIONS = {
	{
		id = "first_bites",
		title = "Recharge Bito with 40 grams of food practice",
		requirement_type = "grams_eaten",
		target_value = 40,
		progress = 0,
		status = "active",
		reward_points = 15,
	},
	{
		id = "arcade_helper",
		title = "Help Bito study by playing 1 food game",
		requirement_type = "game_played",
		target_value = 1,
		progress = 0,
		status = "active",
		reward_points = 10,
	},
	{
		id = "taste_training",
		title = "Practice 3 food steps with Bito",
		requirement_type = "food_step",
		target_value = 3,
		progress = 0,
		status = "active",
		reward_points = 20,
	},
}

local function clone_mission(mission)
	local copy = {}
	for key, value in pairs(mission) do
		copy[key] = value
	end
	return copy
end

local function state()
	local s = storage.get_state()
	if not s then
		storage.init()
		s = storage.get_state()
	end
	s.tasks = s.tasks or {}
	if not s.tasks.missions then
		s.tasks.missions = {}
		for _, mission in ipairs(DEFAULT_MISSIONS) do
			table.insert(s.tasks.missions, clone_mission(mission))
		end
		storage.save_state(s)
	end
	return s.tasks, s
end

function M.all()
	local tasks = state()
	return tasks.missions
end

function M.current_mission()
	local missions = M.all()
	for _, mission in ipairs(missions) do
		if mission.status == "active" then
			return mission
		end
	end
	for _, mission in ipairs(missions) do
		if mission.status == "completed" then
			return mission
		end
	end
	return nil
end

function M.current_description()
	local mission = M.current_mission()
	if not mission then
		return "All missions are complete. Bito is ready for a new adventure."
	end
	return mission.title .. " (" .. (mission.progress or 0) .. "/" .. mission.target_value .. ")"
end

function M.check_task_progress(requirement_type, value)
	local tasks, s = state()
	local completed = {}
	local amount = type(value) == "number" and value or 1

	for _, mission in ipairs(tasks.missions) do
		if mission.status == "active" and mission.requirement_type == requirement_type then
			mission.progress = math.min(mission.target_value, (mission.progress or 0) + amount)
			if mission.progress >= mission.target_value then
				mission.status = "completed"
				table.insert(completed, mission)
			end
		end
	end

	storage.save_state(s)
	return completed
end

function M.claim(id)
	local tasks, s = state()
	for _, mission in ipairs(tasks.missions) do
		if mission.id == id and mission.status == "completed" then
			mission.status = "claimed"
			storage.save_state(s)
			return true, mission
		end
	end
	return false, nil
end

return M
