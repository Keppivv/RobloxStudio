local Areas = workspace:WaitForChild("Areas"):GetChildren()
local player = game.Players.LocalPlayer
local character = player.Character:WaitForChild("Head").Parent

local maxBreakables = 50
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
					breakable = breakables.Breakable_Diamond:Clone()
				end
				breakable.Parent = Area.Breakables
				
				local clean = game.ReplicatedStorage.CleanUp.Clean:Clone()
				clean.Parent = breakable
				clean.Enabled = true
				
				breakable.ClickDetector.MouseClick:Connect(function(me)
					breakable.Clean.Enabled = false
					wait(0.05)
					breakable.Clean.Enabled = true
					breakable.Settings.Health.Value -= 25
					if breakable.Settings.Health.Value <= 0 then
						breakable:Destroy()
					end
				end)
				breakable.Position = Vector3.new(math.random(Area.Position.X - Area.Size.X/6, Area.Position.X + Area.Size.X/6),
					Area.Position.Y,
					math.random(Area.Position.Z - Area.Size.Z/6, Area.Position.Z + Area.Size.Z/6))
				breakable.Position = Vector3.new(breakable.Position.X, breakable.Position.Y + (breakable.Size.Y/1.75), breakable.Position.Z)
			end
		end
	end
	wait(0.1)
end
