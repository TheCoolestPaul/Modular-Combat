function GetRandomWeightedInt(min, max, pow)
	local randDoub = math.Rand(0, 1)
	local result = math.floor( min + ( max + 1 - min ) * ( math.pow( randDoub, pow ) ) )
	return result
end