local char = game.Players.LocalPlayer.Character:WaitForChild("Head").Parent
local BigNumber = require(game.ReplicatedFirst:WaitForChild("BigNumber"))

print(BigNumber.add(50,51))
print(BigNumber.multiply(2,6))
print(BigNumber.subtract(50,40))
wait(0.5)
print(BigNumber.multiply("5","5"))
print(BigNumber.subtract(400000,"5"))
print(BigNumber.add("50",5))
