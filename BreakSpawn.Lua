local Areas = workspace:WaitForChild("Areas"):GetChildren()
local player = game.Players.LocalPlayer
local character = player.Character:WaitForChild("Head").Parent

local maxBreakables = 40
local minDistance = 6
local breakables = game:GetService("ReplicatedStorage"):WaitForChild("Breakables")

-- Check if player is inside the Area in x and y axis
local function isInArea(area, pos)
	if pos.X > area.Position.X + area.Size.X/4 or pos.X < area.Position.X - area.Size.X/4 or
		pos.Z > area.Position.Z + area.Size.Z/4 or pos.Z < area.Position.Z - area.Size.Z/4 then
		return false
	end
	return true
end

-- Function to play different sounds based on the breakable type
local function playSound(name, parent)
	local sound = game.ReplicatedStorage.Sounds.Coins:Clone() -- default sound
	if name == "Breakable_Diamond" then
		sound = game.ReplicatedStorage.Sounds.Diamonds:Clone()
	elseif table.find({"Breakable_Chest", "Breakable_Gift", "Breakable_Safe", "Breakable_Crate", "Breakable_DiamondGift"}, name) then
		sound = game.ReplicatedStorage.Sounds.Boxes:Clone()
	end
	sound.Parent = parent
	sound:Play()
	wait(1)
	sound:Destroy()
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
			end
		end
	else
		local Areas = workspace:WaitForChild("Areas"):GetChildren()
		for i in Areas do
			local parts = Areas[i].Area:GetChildren()
			for x in parts do
				if area.Name == Areas[i].Name then
					parts[x].SurfaceLight.Color = Color3.new(0, 1, 0)
				else
					parts[x].SurfaceLight.Color = Color3.new(1, 0, 0)
				end
			end
		end
	end
end
-- Function to select the breakable
local function selectBreakable()
	local lottery = math.random(0,1000000000)
	if lottery >= 999000000 then
		return game.ReplicatedStorage.Breakables.Breakable_Chest:Clone()
	end
	if lottery >= 950000000 then
		return game.ReplicatedStorage.Breakables.Breakable_Diamond:Clone()
	end
	if lottery >= 900000000 then
		return game.ReplicatedStorage.Breakables.Breakable_Gift:Clone()
	end
	if lottery >= 800000000 then
		return game.ReplicatedStorage.Breakables.Breakable_Safe:Clone()
	end
	if lottery >= 700000000 then
		return game.ReplicatedStorage.Breakables.Breakable_Crate:Clone()
	end
	if lottery >= 600000000 then
		return game.ReplicatedStorage.Breakables.Breakable_BigCoin:Clone()
	end
	if lottery >= 500000000 then
		return game.ReplicatedStorage.Breakables.Breakable_MedCoin:Clone()
	end
	return game.ReplicatedStorage.Breakables.Breakable_LowCoin:Clone()
end
-- Function to choose spawn location
local function determineSpawnLocation(area, breakable)
	local currentBreakables = area.Breakables:GetChildren()
	local x = math.random(area.Position.X - area.Size.X/6, area.Position.X + area.Size.X/6)
	local z = math.random(area.Position.Z - area.Size.Z/6, area.Position.Z + area.Size.Z/6)
	local y = area.Position.Y + (breakable.Size.Y/1.75)
	local lenCanSpawn = true
	if rawlen(currentBreakables) == 0 then
		return true, x, y, z
	else
		for i in currentBreakables do
			if (currentBreakables[i].Position - Vector3.new(x,y,z)).Magnitude <= minDistance then
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
	breakable.ClickDetector.MouseClick:Connect(function()
		playSound(breakable.Name, character.Head)
	end)
	
	local updt = game.ReplicatedStorage.CleanUp.Update:Clone()
	updt.Parent = breakable
	local cln = game.ReplicatedStorage.CleanUp.Clean:Clone()
	cln.Parent = breakable
	local brkblx = game.ReplicatedStorage.CleanUp.Breakable_Check:Clone()
	brkblx.Parent = breakable
	
	updt.Enabled = true
	cln.Enabled = true
	brkblx.Enabled = true
end
-- Function to handle the "lottery" system for spawning breakables
local function spawnBreakable(area)
	local currentBreakables = #area.Breakables:GetChildren()
	if currentBreakables >= maxBreakables then return end -- No need to spawn more breakables

	local breakable = selectBreakable() -- Function to be defined for selecting breakable based on lottery
	if not breakable then return end -- No breakable selected

	local canSpawn, x, y, z = determineSpawnLocation(area, breakable) -- Function to be defined for determining spawn location
	if not canSpawn then return end -- Can't spawn at the determined location

	breakable.Position = Vector3.new(x, y, z)
	breakable.Parent = area.Breakables
	setupBreakable(breakable) -- Function to be defined for setting up the breakable (click detector, cleanup, etc.)
end

-- Main loop
while true do
	local currentArea = getCurrentArea()
	updateLights()

	if currentArea then
		spawnBreakable(currentArea)
	end

	wait(0.15)
end
