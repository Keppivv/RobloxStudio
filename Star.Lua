wait(15)
local Star1 = script.Parent.Star1
local Star2 = script.Parent.Star2
local Star3 = script.Parent.Star3

local minTime = 4 -- in Seconds!!
local maxTime = 25 -- ^!!^ -- bat, maybe?

local function dimStar()
	local starNumber = math.random(1,3)
	if starNumber == 1 then
		local stepper = true
		while stepper do
			Star1.ImageTransparency -= 0.05
			Star1.Rotation += 5
			if Star1.ImageTransparency <= 0 then
				stepper = false
			end
			wait(0.01)
		end
		stepper = true
		while stepper do
			Star1.ImageTransparency += 0.03
			Star1.Rotation -= 8
			if Star1.ImageTransparency >= 1 then
				stepper = false
			end
			wait(0.01)
		end
		Star1.Rotation = 0
	end
	if starNumber == 2 then
		local stepper = true
		while stepper do
			Star2.ImageTransparency -= 0.04
			Star2.Rotation += 6
			if Star2.ImageTransparency <= 0 then
				stepper = false
			end
			wait(0.01)
		end
		stepper = true
		while stepper do
			Star2.ImageTransparency += 0.05
			Star2.Rotation -= 5
			if Star2.ImageTransparency >= 1 then
				stepper = false
			end
			wait(0.01)
		end
		Star2.Rotation = 0
	end
	if starNumber == 3 then
		local stepper = true
		while stepper do
			Star3.ImageTransparency -= 0.045
			Star3.Rotation += 8
			if Star3.ImageTransparency <= 0 then
				stepper = false
			end
			wait(0.01)
		end
		stepper = true
		while stepper do
			Star3.ImageTransparency += 0.04
			Star3.Rotation -= 7
			if Star3.ImageTransparency >= 1 then
				stepper = false
			end
			wait(0.01)
		end
		Star3.Rotation = 0
	end
	print(starNumber)
	wait(math.random(minTime, maxTime))
	dimStar()
end
dimStar()
