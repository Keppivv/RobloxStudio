local HealthGuiText = script.Parent.Health.Label
local HealthGuiBar = script.Parent.Health.Background.Bar
while true do
	local real_Health = script.Parent.Settings.Health.Value
	if real_Health <= 0 then
		real_Health = 0
	end
	HealthGuiText.Text = real_Health .. "hp"
	wait(0.1)
end
