local Players = game:GetService("Players")
local key = "test01_DataTable_"
local store = game:GetService("DataStoreService")
local dataStore = store:GetDataStore("DataStore")
-- cAsE sEnSiTivE!

-- Create folder in ReplicatedStorage called "Datas"
-- Create sub folders in Datas {"Abilities", "Assets", "Capital", "Perks", "Pets"}

-- Object creation -> "Configuration" objType as a child for selected sub folder
-- eg. Obj "2x Money" instance as Configuration type
-- Configuration instance should be named as the obj name
-- As for the childs of the instanced Configuration file you *HAVE* to..
-- have 2 StringValues called "e_Name" and "Class"
-- Class name is the parent folder name eg Capital, Pets..
-- e_Name is the name of the object, named such due "Name" beign attribute of obj already>>
-- but !! IMPORTTANT !! it needs to be the same name as obj, eg "2x Money"

-- Additional data can be added as a child to the Configuration file
-- But custom data can't be modified and saved, default data loads on startup
-- and custom data is lost.

--

local function onJoin(player)
	local success, fail = pcall(function()
		local DataFolder = Instance.new("Folder")
		DataFolder.Name = "DataFolder"
		DataFolder.Parent = player
		local nameTable = {"Abilities", "Assets", "Capital", "Perks", "Pets"}
		
		for i in nameTable do
			local folder = Instance.new("Folder")
			folder.Name = nameTable[i]
			folder.Parent = DataFolder
		end
	end)
	if success then
		return true
	else
		print(fail)
		return false
	end
end
local function loadData(player, data)
	if data == nil then end
	if data == {} then end
	for i in data do
		local parent = player.DataFolder:FindFirstChild(tostring(data[i][1]))
		local clonable = game.ReplicatedStorage.Datas:FindFirstChild(data[i][1]):FindFirstChild(data[i][2]):Clone()
		clonable.Parent = parent
	end
end
local function saveData(player)
	local kids = player.DataFolder:GetChildren()
	local dataTable = {}
	for i in kids do
		if #kids[i]:GetChildren() >= 1 then
			local dataValues = kids[i]:GetChildren()
			for x in dataValues do
				local infoTable = {dataValues[x].Class.Value, dataValues[x].e_Name.Value}
				table.insert(dataTable, infoTable)
			end
		end
	end
	local playerKey = key .. player.UserId
	dataStore:SetAsync(playerKey, dataTable)
	wait(12)
	saveData(player)
end
Players.PlayerAdded:Connect(function(player)
	local playerCharacter = player.Character or player.CharacterAdded:Wait()
	local playerKey = key .. player.UserId
	local createData = onJoin(player)
	while createData ~= true do
		if createData == false then
			onJoin(player)
		end
		wait(0.1)
	end
	local data = nil
	local succ, err = pcall(function()
		data = dataStore:GetAsync(playerKey)
	end)
	if succ then
		loadData(player, data)
	end
	wait(3)
	saveData(player)
end)
