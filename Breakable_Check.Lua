local detector = script.Parent.ClickDetector
local head = game.Players.LocalPlayer.Character:WaitForChild("Head")
local function playSound()
	local sound = game.ReplicatedStorage.Sounds.Coins:Clone() -- default sound
	sound.Parent = head
	local clean = game.ReplicatedStorage.CleanUp.Clean:Clone()
	clean.Time.Value = 2
	clean.Parent = sound
	clean.Enabled = true
	sound:Play()
end


detector.MouseClick:Connect(function()
	spawn(function()
		playSound()
	end)
	script.Parent.Settings.Health.Value -= 10
	if script.Parent.Settings.Health.Value <= 0 then
		script.Parent:ScaleTo(0.001)
		script.Parent.ClickDetector:Destroy()
		wait(0.05)
		script.Parent:Destroy()
	end
end)
