-- Place in ReplicatedStorage or ReplicatedFirst. ModuleScript

local BigNumber = {}

-- Function to split a large number string into chunks of 3 digits
function BigNumber.splitNumber(numStr)
	local chunks = {}
	local length = string.len(numStr)
	for i = length, 1, -3 do
		local chunk = string.sub(numStr, math.max(i - 2, 1), i)
		table.insert(chunks, 1, tonumber(chunk)) -- Insert at the beginning
	end
	return chunks
end

-- Function to combine chunks back into a large number string
function BigNumber.combineChunks(chunks)
	local numStr = ""
	for i, chunk in ipairs(chunks) do
		if i == 1 then
			numStr = tostring(chunk)
		else
			numStr = numStr .. string.format("%03d", chunk)
		end
	end
	return numStr
end

-- Function to add two large numbers
function BigNumber.add(numStr1, numStr2)
	local chunks1 = BigNumber.splitNumber(numStr1)
	local chunks2 = BigNumber.splitNumber(numStr2)
	local maxLength = math.max(#chunks1, #chunks2)
	local carry = 0
	local resultChunks = {}

	for i = 1, maxLength do
		local sum = (chunks1[i] or 0) + (chunks2[i] or 0) + carry
		carry = math.floor(sum / 1000)
		table.insert(resultChunks, sum % 1000)
	end

	if carry > 0 then
		table.insert(resultChunks, carry)
	end

	return BigNumber.combineChunks(resultChunks)
end

-- Function to subtract one large number from another
function BigNumber.subtract(numStr1, numStr2)
	local chunks1 = BigNumber.splitNumber(numStr1)
	local chunks2 = BigNumber.splitNumber(numStr2)
	local resultChunks = {}
	local borrow = 0

	for i = 1, #chunks1 do
		local sub = (chunks1[i] or 0) - (borrow + (chunks2[i] or 0))
		if sub < 0 then
			borrow = 1
			sub = sub + 1000
		else
			borrow = 0
		end
		table.insert(resultChunks, sub)
	end

	-- Handle leading zeros in the final result
	while #resultChunks > 1 and resultChunks[#resultChunks] == 0 do
		table.remove(resultChunks)
	end

	return BigNumber.combineChunks(resultChunks)
end

-- Function to multiply a large number by another number (not optimized for large multipliers)
function BigNumber.multiply(numStr1, multiplier)
	local chunks1 = BigNumber.splitNumber(numStr1)
	local carry = 0
	local resultChunks = {}

	for i = 1, #chunks1 do
		local product = (chunks1[i] * multiplier) + carry
		carry = math.floor(product / 1000)
		resultChunks[i] = product % 1000
	end

	if carry > 0 then
		table.insert(resultChunks, carry)
	end

	return BigNumber.combineChunks(resultChunks)
end

return BigNumber
