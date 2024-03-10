player = game.Players.LocalPlayer
screen = player.PlayerGui:WaitForChild("LoadingScreen")
stock = screen:WaitForChild("Stock")
screen.Enabled = true
otherTable = player.PlayerGui:GetChildren()
enableTable = {}
for x in otherTable do
	if otherTable[x].Enabled == true then
		if otherTable[x].Name ~= "LoadingScreen" then
			table.insert(enableTable, otherTable[x])
		end
	end
end
onset = 0
while onset < 225 do
	onset += 1
	stock.BackgroundColor3 = Color3.new(onset/225, onset/225, onset/225)
	task.wait()
end
for i=1, 100 do
	stock.BackgroundTransparency = i / 100
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
