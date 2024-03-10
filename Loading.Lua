local sgui = game:GetService("StarterGui")
sgui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
player = game.Players.LocalPlayer
screen = player.PlayerGui:WaitForChild("LoadingScreen")
stock = screen:WaitForChild("Stock")
screen.Enabled = true
load = stock:FindFirstChild("L_Text")
otherTable = player.PlayerGui:GetChildren()
enableTable = {}
for x in otherTable do
	if otherTable[x].Enabled == true then
		if otherTable[x].Name ~= "LoadingScreen" then
			table.insert(enableTable, otherTable[x])
			otherTable[x].Enabled = false
		end
	end
end
onset = 0
while onset < 225 do
	if 1 > math.random(0,35) then
		if rawlen(load.Text) >= 10 then
			load.Text = "Loading"
		else
			load.Text = load.Text .. "."
		end
	end
	onset += 1
	stock.BackgroundColor3 = Color3.new(onset/225, onset/225, onset/225)
	task.wait()
end
for i=1, 225 do
	if 1 > math.random(0,35) then
		if rawlen(load.Text) >= 10 then
			load.Text = "Loading"
		else
			load.Text = load.Text .. "."
		end
	end
	load.TextTransparency = i / 225
	load.UIStroke.Transparency = i / 225
	stock.BackgroundTransparency = i / 225
	stock.BackgroundColor3 = Color3.new(225-i, 225-i, 225-i)
	task.wait()
end
screen.Enabled = false
if rawlen(enableTable) >= 1 then
	for i in otherTable do
		for x in enableTable do
			if enableTable[x].Name == otherTable[i].Name then
				otherTable[i].Enabled = true
			end
		end
	end
end
