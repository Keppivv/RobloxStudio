local HealthGuiText = script.Parent.Health.Label
local HealthGuiBar = script.Parent.Health.Background.Bar

while true do
	local real_Health = script.Parent.Settings.Health.Value
	if real_Health <= 0 then
		real_Health = 1
	end
	HealthGuiText.Text = real_Health .. "hp"
	local percentage = (real_Health / script.Parent.Settings.MaxHealth.Value)
	HealthGuiBar.Size = UDim2.new(percentage, 0, 1, 0)
	wait(0.25)
end
