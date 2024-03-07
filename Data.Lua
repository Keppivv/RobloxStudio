-- ServerScriptService
local Players = game:GetService("Players")

local function onJoin(player)
	local success, fail = pcall(function()
		local DataFolder = Instance.new("Folder")
		DataFolder.Name = "DataFolder"
		DataFolder.Parent = player
		
		local Pets = Instance.new("Folder")
		Pets.Name = "Pets"
		Pets.Parent = DataFolder
		
		local Capital = Instance.new("Folder")
		Capital.Name = "Capital"
		Capital.Parent = DataFolder
		
		local Assets = Instance.new("Folder")
		Assets.Name = "Assets"
		Assets.Parent = DataFolder
		
		local Perks = Instance.new("Folder")
		Perks.Name = "Perks"
		Perks.Parent = DataFolder
		
		local Abilities = Instance.new("Folder")
		Abilities.Name = "Abilities"
		Abilities.Parent = DataFolder
	end)
	if success then
		return true
	else
		print(fail)
		return false
	end
end
local function saveData(player)
	local kids = player.DataFolder:GetChildren()
	local dataTable = {}
	for i in kids do
		if #kids[i]:GetChildren() >= 1 then
			local dataValues = kids[i]:GetChildren()
			for x in dataValues do
				local infoTable = {dataValues[x].Class.Value, dataValues[x].e_Name.Value, dataValues[x].Boost.Value, dataValues[x].UID.Value}
				table.insert(dataTable, infoTable)
			end
		end
	end
	print(dataTable)
	wait(8)
	saveData(player)
end
Players.PlayerAdded:Connect(function(player)
	local playerCharacter = player.Character or player.CharacterAdded:Wait()
	local createData = onJoin(player)
	while createData ~= true do
		if createData == false then
			onJoin(player)
		end
		wait(0.1)
	end
	wait(5)
	saveData(player)
end)
