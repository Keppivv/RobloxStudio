wait(3)
player = game.Players.LocalPlayer
Manager = player.PlayerGui:WaitForChild("Manager")
Credits = Manager:WaitForChild("Credits").TextLabel
Crowns = Manager:WaitForChild("Crowns").TextLabel

while true do
	local cred = player:WaitForChild("DataFolder"):WaitForChild("Capital"):WaitForChild("Crop Credits").Credits.Value
	local crow = player:WaitForChild("DataFolder"):WaitForChild("Capital"):WaitForChild("Crop Crowns").Credits.Value
	Credits.Text = cred
	Crowns.Text = crow
	wait(0.1)
end
