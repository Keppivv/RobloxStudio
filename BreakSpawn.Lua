local Areas = workspace:WaitForChild("Areas"):GetChildren()
local player = game.Players.LocalPlayer
local character = player.Character:WaitForChild("Head").Parent

local debugBol = false
local maxBreakables = 88
local minDistance = 4.20*1.341234
local sleepTime = 0.2
local breakables = game:GetService("ReplicatedStorage"):WaitForChild("Breakables")

-- Check if player is inside the Area in z and y axis
local function isInArea(area, pos)
	if pos.X > area.Position.X + area.Size.X/2 or pos.X < area.Position.X - area.Size.X/2 or
		pos.Z > area.Position.Z + area.Size.Z/2 or pos.Z < area.Position.Z - area.Size.Z/2 then
		return false
	end
	return true
end
-- Function to determine which Area the player is currently in
local function getCurrentArea()
	local Areas = workspace:WaitForChild("Areas"):GetChildren()
	for _, area in ipairs(Areas) do
		if isInArea(area, player.Character.PrimaryPart.Position) then
			return area
		end
	end
	return nil -- No current area found
end

-- Function to update the light colors based on player's area
local function updateLights()
	local area = getCurrentArea()
	if area == nil then
		local Areas = workspace:WaitForChild("Areas"):GetChildren()
		for i in Areas do
			local parts = Areas[i].Area:GetChildren()
			for x in parts do
				parts[x].SurfaceLight.Color = Color3.new(1, 0, 0)
				parts[x].Color = Color3.new(1,0,0)
			end
		end
	else
		local Areas = workspace:WaitForChild("Areas"):GetChildren()
		for i in Areas do
			local parts = Areas[i].Area:GetChildren()
			for x in parts do
				if area.Name == Areas[i].Name then
					parts[x].SurfaceLight.Color = Color3.new(0, 1, 0)
					parts[x].Color = Color3.new(0,1,0)
				else
					parts[x].SurfaceLight.Color = Color3.new(1, 0, 0)
					parts[x].Color = Color3.new(1,0,0)
				end
			end
		end
	end
end
-- Function to select the breakable
local function selectBreakable()
	local brkbls = game.ReplicatedStorage.Breakables:GetChildren()
	local randomList = {}
	while rawlen(randomList) ~= rawlen(brkbls) do
		local x = math.random(1, rawlen(brkbls))
		if x >= 1 then
			local detect = false
			for i in randomList do
				if randomList[i] == x then
					detect = true
				end
			end
			if not detect then
				table.insert(randomList, x)
			end
		else
			table.insert(randomList, x)
		end
	end
	for i in brkbls do
		local ind = string.split(brkbls[randomList[i]].Settings.Chance.Value, "/")
		local min, max = tonumber(ind[1]), tonumber(ind[2])
		local lottery = math.random(1, max)
		if lottery <= min then
			if debugBol then
				print("--- --- --- --- ---")
				print("Spawning: " .. brkbls[randomList[i]].Name)
				print("randomList: ", randomList)
				print("min | max: ", min, " | ", max)
				print("lottery: ", lottery)
				print("index: ", i)
				print("random index: ", randomList[i])
				print("brkblsList: ", brkbls)
				print("--- --- --- --- ---")
			end
			return game.ReplicatedStorage.Breakables:FindFirstChild(brkbls[randomList[i]].Name):Clone()
		end
	end
	return game.ReplicatedStorage.Breakables.SmallCoin:Clone()
end
-- Function to choose spawn location
local function determineSpawnLocation(area, breakable)
	local currentBreakables = area.Breakables:GetChildren()
	local x = math.random(area.Position.X - area.Size.X/2.3, area.Position.X + area.Size.X/2.3)
	local z = math.random(area.Position.Z - area.Size.Z/2.3, area.Position.Z + area.Size.Z/2.3)
	local y = area.Position.Y + (breakable.PrimaryPart.Size.Y/2)
	
	local lenCanSpawn = true
	if rawlen(currentBreakables) == 0 then
		return true, x, y, z
	else
		for i in currentBreakables do
			if (currentBreakables[i]:GetPivot().Position - Vector3.new(x,y,z)).Magnitude <= minDistance then
				lenCanSpawn = false
				return false, x, y, z
			end
		end
		if lenCanSpawn then
			return true, x, y, z
		end
	end
end
-- Function to setup Breakables
local function setupBreakable(breakable)
	local updt = game.ReplicatedStorage.CleanUp.Update:Clone()
	updt.Parent = breakable
	local cln = game.ReplicatedStorage.CleanUp.Clean:Clone()
	cln.Time.Value = 60*5
	cln.Parent = breakable
	local brkblx = game.ReplicatedStorage.CleanUp.Breakable_Check:Clone()
	brkblx.Parent = breakable
	
	updt.Enabled = true
	cln.Enabled = true
	brkblx.Enabled = true
end
-- Function to handle Lucky
local function isLucky()
	local luck = 1 -- 1%
	if math.random(0,100) <= luck then
		return true
	else
		return false
	end
end
-- Function to handle Lucky GUI
local function luckyGui(breakable)
	local floating = breakable.Floating
	local multi = math.random(2,6)
	floating.Enabled = true
	floating.Label.Text = tostring(multi) .. "x Reward!"
	local luck = Instance.new("IntValue")
	luck.Name = "Luck"
	luck.Parent = breakable.Settings
	luck.Value = multi
end
-- Scales breakable from 0 to 1
local function scaleFunction(breakable)
	local scaler = true
	local counter = 0
	while scaler do
		counter += 1
		breakable:ScaleTo((0.1*counter))
		if counter == 10 then
			scaler = false
		end
		wait(0.01)
	end
end
-- Function to handle the "lottery" system for spawning breakables
local function spawnBreakable(area)
	local currentBreakables = #area.Breakables:GetChildren()
	if currentBreakables >= maxBreakables then return end -- No need to spawn more breakables

	local breakable = selectBreakable()
	if not breakable then return end -- No breakable selected

	local canSpawn, x, y, z = determineSpawnLocation(area, breakable)
	if not canSpawn then return end -- Can't spawn at the determined location
	
	local isBreakableLucky = isLucky()
	if isBreakableLucky then
		luckyGui(breakable)
	end
	
	breakable:TranslateBy(Vector3.new(x,y,z)-breakable.PrimaryPart.Position)
	local rotation = CFrame.Angles(0, math.rad(math.random(0,180)), 0)
	local modelCFrame = breakable:GetPivot()
	breakable:ScaleTo(0.001)
	breakable:PivotTo(modelCFrame * rotation)
	breakable.Parent = area.Breakables
	spawn(function()
		scaleFunction(breakable)
	end)
	local area_num = Instance.new("IntValue")
	area_num.Name = "AreaNumber"
	local depotName = string.sub(tostring(area), rawlen(area.Name)-2)
	area_num.Value = tonumber(depotName)
	area_num.Parent = breakable
	setupBreakable(breakable)
end

-- Main loop
while true do
	local currentArea = getCurrentArea()
	updateLights()

	if currentArea then
		spawnBreakable(currentArea)
	end

	wait(sleepTime)
end
