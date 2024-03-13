pet = script.Parent:WaitForChild("Pet")
player = game.Players.LocalPlayer
character = player.Character
leg = character:WaitForChild("LeftFoot")

petAttackDelay = 0.25 / 5

if #workspace:WaitForChild("Pets"):GetChildren() == 0 then
	local f = Instance.new("Folder")
	f.Name = player.Name
	f.Parent = workspace.Pets
else
	local d = workspace.Pets:GetChildren()
	local x = false
	for i in d do
		if d[i].Name == player.Name then
			x = true
		end
	end
	if not x then
		local f = Instance.new("Folder")
		f.Name = player.Name
		f.Parent = workspace.Pets
	end
end
pet.Parent = workspace:WaitForChild("Pets"):WaitForChild(player.Name)
pet.Position = Vector3.new(11.5, 123.425, 100.75)
sVal = 0
fPlay = true
aPlay = false
function areaAttack()
	local area = game.Workspace.Areas:FindFirstChild(player.areaN.Value)
	while aPlay do
		local brks = area.Breakables:GetChildren()
		local target = brks[math.random(1,#brks)]
		pet.Position = target.Primary.Position + Vector3.new(0, 5, 0)
		local suc, err = pcall(function()
			while target.Settings.Health.Value >= 0 do
				target.Settings.Health.Value -= 5
				wait(petAttackDelay)
			end
		end)
		wait(petAttackDelay)
		if player.inArea.Value == false then
			aPlay = false
			spawn(function()
				fPlay = true
				followPlayer()
			end)
		end
	end
end
function followPlayer()
	while fPlay do
		local pos = game.Workspace:FindFirstChild(player.Name).LeftFoot.Position
		local rot = game.Workspace:FindFirstChild(player.Name).Head.Rotation
		pet.Position = pos + Vector3.new(10, 3, -3)
		pet.Rotation = rot
		task.wait()
		if player.inArea.Value == true then
			fPlay = false
			spawn(function()
				aPlay = true
				areaAttack()
			end)
		end
	end
end
spawn(function()
	followPlayer()
end)
