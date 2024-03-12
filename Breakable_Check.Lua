local detector = script.Parent.ClickDetector
local head = game.Players.LocalPlayer.Character:WaitForChild("Head")
local player = game.Players.LocalPlayer
local function playSound()
	local sound = game.ReplicatedStorage.Sounds.Coins:Clone() -- default sound
	sound.Parent = head
	local clean = game.ReplicatedStorage.CleanUp.Clean:Clone()
	clean.Time.Value = 2
	clean.Parent = sound
	clean.Enabled = true
	sound:Play()
	return true
end
local function breaking(player)
	local child = script.Parent.Settings:GetChildren()
	local isLucky = false
	local luckyNumber = 0
	for i in child do
		if child[i].Name == "Luck" then
			isLucky = true
			luckyNumber = tostring(child[i].Value)
		end
	end
	local breakable_multi = tonumber(script.Parent.Settings.Multiplier.Value)
	local area_multi = tonumber(script.Parent.AreaNumber.Value)
	local minReward, maxReward = 1, 25
	if isLucky then
		minReward = minReward * luckyNumber
		maxReward = maxReward * luckyNumber
	end
	minReward = minReward * (1 + (breakable_multi / 100) + (area_multi / 100))
	maxReward = maxReward * (1 + (breakable_multi / 100) + (area_multi / 100))
	local crops = 0
	local crowns = 0
	crops += math.random(minReward,maxReward)
	if math.random(0,100) > 75 then
		crowns += math.random((1+(minReward / 2)), (1+(maxReward)))
	end
	game.ReplicatedStorage.Events.Breakable_Break:FireServer(crops, crowns)
	task.wait()
	script.Parent:Destroy()
end

local helt = script.Parent.Settings.Health
helt.Changed:Connect(function(me)
	local che = playSound()	
	if script.Parent.Settings.Health.Value <= 0 then
		script.Parent:ScaleTo(0.001)
		script.Parent.ClickDetector:Destroy()
		task.wait()
		breaking(player)
	end
end)

detector.MouseClick:Connect(function(player)
	script.Parent.Settings.Health.Value -= 10
end)
