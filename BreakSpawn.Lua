local Areas = workspace:WaitForChild("Areas"):GetChildren()
local player = game.Players.LocalPlayer
local character = player.Character:WaitForChild("Head").Parent

local maxBreakables = 40
local currentBreakables = 0
local breakables = game:GetService("ReplicatedStorage"):WaitForChild("Breakables")

-- if player is inside the Area in x and y axis
local function isInArea(area, pos)
	if pos.X > area.Position.X + area.Size.X/4 or pos.X < area.Position.X - area.Size.X/4 then
		return false
	end
	if pos.Z > area.Position.Z + area.Size.Z/4 or pos.Z < area.Position.Z - area.Size.Z/4 then
		return false
	end
	return true
end

local function sounder(name)
	local sound = nil
	if name == "Breakable_Diamond" then
		sound = game.ReplicatedStorage.Sounds.Diamonds:Clone()
	else
		sound = game.ReplicatedStorage.Sounds.Coins:Clone()
	end
	sound.Parent = player.Character.Head
	sound:Play()
	wait(1)
	sound:Destroy()
end

while true do
	local Areas = workspace:WaitForChild("Areas"):GetChildren()
	local Area = nil
	for area in Areas do
		local t_val = isInArea(Areas[area], player.Character.PrimaryPart.Position)
		if t_val == true then
			Area = Areas[area]
			break
		end
	end
	for i in Areas do
		if Area == nil then
			local sides = Areas[i].Area:GetChildren()
			for x in sides do
				sides[x].SurfaceLight.Color = Color3.new(1, 0, 0)
			end
		else
			local sides = Areas[i].Area:GetChildren()
			if Areas[i].Name == Area.Name then
				for x in sides do
					sides[x].SurfaceLight.Color = Color3.new(0, 1, 0)
				end
			else
				for x in sides do
					sides[x].SurfaceLight.Color = Color3.new(1, 0, 0)
				end
			end
		end
	end
	if Area == nil then
		--skipping
	else
		local val = isInArea(Area, player.Character.PrimaryPart.Position)
		if val == true then
			currentBreakables = rawlen(Area.Breakables:GetChildren())
			if currentBreakables < maxBreakables then
				local lottery = math.random(1, 1000000)
				local breakable = nil
				if lottery < 800000 then
					local lotteryTwo = math.random(1,1000000)
					if lotteryTwo < 750000 then
						breakable = breakables.Breakable_LowCoin:Clone()
					end
					if lotteryTwo >= 750000 then
						breakable = breakables.Breakable_MedCoin:Clone()
					end
					if lotteryTwo > 925000 then
						breakable = breakables.Breakable_BigCoin:Clone()
					end
				end
				if lottery >= 800000 then
					breakable = breakables.Breakable_Crate:Clone()
				end
				if lottery > 850000 then
					breakable = breakables.Breakable_Safe:Clone()
				end
				if lottery > 900000 then
					breakable = breakables.Breakable_Gift:Clone()
				end
				if lottery > 925000 then
					breakable = breakables.Breakable_Diamond:Clone()
				end
				if lottery > 985000 then
					breakable = breakables.Breakable_Chest:Clone()
				end
				breakable.Particles.Sparkles.Enabled = false
				breakable.Floating.Enabled = false
				local lottery = math.random(1, 1000000)
				if lottery > 990000 then
					breakable.Particles.Sparkles.Enabled = true
					breakable.Floating.Enabled = true
					local multi = math.random(2,10)
					breakable.Settings.Multiplier.Value += multi
					if breakable.Name == "Breakable_Chest" then
						breakable.Floating.Label.Text = string.format(multi .. "x Reward")
					end
					if breakable.Name == "Breakable_Diamond" then
						breakable.Floating.Label.Text = string.format(multi .. "x Diamonds")
					end
					if breakable.Name ~= "Breakable_Diamond" then
						if breakable.Name ~= "Breakable_Chest" then
							breakable.Floating.Label.Text = string.format(multi .. "x Coins")
						end
					end
				end
				
				--breakable.Parent = Area.Breakables
				local clean = game.ReplicatedStorage.CleanUp.Clean:Clone()
				clean.Parent = breakable
				clean.Enabled = true
				local updtr = game.ReplicatedStorage.CleanUp.Update:Clone()
				updtr.Parent = breakable
				updtr.Enabled = true
				breakable.ClickDetector.MouseClick:Connect(function(me)
					spawn(function()
						sounder(breakable.Name)
					end)
					breakable.Clean.Enabled = false
					wait(0.05)
					breakable.Clean.Enabled = true
					breakable.Settings.Health.Value -= 13
					if breakable.Settings.Health.Value <= 0 then
						breakable:Destroy()
					end
				end)
				local canSpawn = true
				local positions = Area.Breakables:GetChildren()
				local x = math.random(Area.Position.X - Area.Size.X/6, Area.Position.X + Area.Size.X/6)
				local z = math.random(Area.Position.Z - Area.Size.Z/6, Area.Position.Z + Area.Size.Z/6)
				local y = Area.Position.Y + (breakable.Size.Y/1.75)
				--print(rawlen(positions))
				if rawlen(positions) == 0 then
					breakable.Position = Vector3.new(x,y,z)
				else
					for i in positions do
						if ((positions[i].Position - Vector3.new(x,y,z)).Magnitude) <= 8 then
							canSpawn = false
							break
						end
					end
				end
				if canSpawn then
					breakable.Position = Vector3.new(x,y,z)
					breakable.Parent = Area.Breakables
				else
					breakable:Destroy()
				end
			end
		end
	end
	wait(0.15)
end
