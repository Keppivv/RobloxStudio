local HealthGuiText = script.Parent.Health.Label
local HealthGuiBar = script.Parent.Health.Background.Bar
script.Parent.Health.Background.Visible = false
script.Parent.Health.Background.Bar.Visible = false
script.Parent.Floating.Label.Text = ""
script.Parent.Floating.Enabled = false
while true do
	local real_Health = script.Parent.Settings.Health.Value
	if real_Health <= 0 then
		real_Health = 1
	end
	HealthGuiText.Text = real_Health .. "hp"
	wait(0.1)
end
