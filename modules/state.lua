local M = { current = nil }

local function all_screens()
	return {
		{ id = "home", url = hash("/main/ui/main#gui") },
		{ id = "meal", url = hash("/main/ui/meal#gui") },
		{ id = "glossary", url = hash("/main/ui/glossary#gui") },
		{ id = "parent", url = hash("/main/ui/parent#gui") },
	}
end

function M.switch(id)
	M.current = id
	for _, s in ipairs(all_screens()) do
		msg.post(s.url, hash("set_visible"), { value = (s.id == id) })
	end
end

return M