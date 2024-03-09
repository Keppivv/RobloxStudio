wait(5)
local char = game.Players.LocalPlayer.Character:WaitForChild("Head")
local Star = script.Parent.FeatureImage:GetChildren()
local dimTime = 0.05
local minTime = 2 -- in Seconds!!
local maxTime = 20 -- ^!!^ -- bat, maybe?

local function Stars()
	local star = Star[math.random(1,#Star)]
	while star.ImageTransparency ~= 0 do
		star.ImageTransparency -= 0.05
		star.Rotation += 15
		wait(dimTime)
	end
	while star.ImageTransparency ~= 1 do
		star.ImageTransparency += 0.05
		star.Rotation -= 16
		wait(dimTime)
	end
	star.ImageTransparency = 1
	star.Rotation = -180
	wait(math.random(minTime,maxTime))
	spawn(function()
		Stars()
	end)
end
spawn(function()
	Stars()
end)
