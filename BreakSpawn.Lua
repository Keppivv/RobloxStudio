local Areas = workspace:WaitForChild("Areas"):GetChildren()
local player = game.Players.LocalPlayer
local character = player.Character:WaitForChild("Head").Parent

local maxBreakables = 40
local minDistance = 6
local breakables = game:GetService("ReplicatedStorage"):WaitForChild("Breakables")

-- Check if player is inside the Area in z and y axis
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
		return game.ReplicatedStorage.Breakables.SmallDiamond:Clone()
	end
	if lottery >= 950000000 then
		return game.ReplicatedStorage.Breakables.SmallDiamond:Clone()
	end
	if lottery >= 900000000 then
		return game.ReplicatedStorage.Breakables.BigCoin:Clone()
	end
	if lottery >= 800000000 then
		return game.ReplicatedStorage.Breakables.BigCoin:Clone()
	end
	if lottery >= 700000000 then
		return game.ReplicatedStorage.Breakables.MediumCoin:Clone()
	end
	if lottery >= 600000000 then
		return game.ReplicatedStorage.Breakables.MediumCoin:Clone()
	end
	if lottery >= 500000000 then
		return game.ReplicatedStorage.Breakables.SmallCoin:Clone()
	end
	return game.ReplicatedStorage.Breakables.SmallCoin:Clone()
end
-- Function to choose spawn location
local function determineSpawnLocation(area, breakable)
	local currentBreakables = area.Breakables:GetChildren()
	local x = math.random(area.Position.X - area.Size.X/6, area.Position.X + area.Size.X/6)
	local z = math.random(area.Position.Z - area.Size.Z/6, area.Position.Z + area.Size.Z/6)
	local y = area.Position.Y + (breakable.PrimaryPart.Size.Y/4.5)
	
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
	floating.Label.Text = "2x reawrd"
	local coinType = {"SmallCoin", "MediumCoin", "BigCoin", "CoinChest"}
	local rewardType = {"SmallChest", "BigChest"}
	local diamondType = {"SmallDiamond", "MediumDiamond", "BigDiamond", "DiamondChest"}
	for i in coinType do
		if coinType[i] == breakable.Name then
			floating.Label.Text = multi .. "x Coins"
		end
	end
	for i in rewardType do
		if rewardType[i] == breakable.Name then
			floating.Label.Text = multi .. "x Reward"
		end
	end
	for i in diamondType do
		if diamondType[i] == breakable.Name then
			floating.Label.Text = multi .. "x Diamonds"
		end
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
	local rotation = CFrame.Angles(0, 0, math.rad(math.random(-180,180)))
	local modelCFrame = breakable:GetPivot()
	breakable:PivotTo(modelCFrame * rotation)
	
	breakable.Parent = area.Breakables
	setupBreakable(breakable)
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
