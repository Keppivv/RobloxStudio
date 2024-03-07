local detector = script.Parent.ClickDetector
detector.MouseClick:Connect(function()
	script.Parent.Settings.Health.Value -= 10
	if script.Parent.Settings.Health.Value <= 0 then
		wait(0.05)
		script.Parent:Destroy()
	end
end)
