function GetRandomWeightedInt(min, max, pow)
	local randDoub = math.Rand(0, 1)
	local result = math.floor( min + ( max + 1 - min ) * ( math.pow( randDoub, pow ) ) )
	return result
end

local LoadedSounds
if CLIENT then
	LoadedSounds = {} -- this table caches existing CSoundPatches
end

function ReadSound( FileName )
	local sound
	local filter
	if SERVER then
		filter = RecipientFilter()
		filter:AddAllPlayers()
	end
	if SERVER or !LoadedSounds[FileName] then
		-- The sound is always re-created serverside because of the RecipientFilter.
		sound = CreateSound( game.GetWorld(), FileName, filter ) -- create the new sound, parented to the worldspawn (which always exists)
		if sound then
			sound:SetSoundLevel( 0 ) -- play everywhere
			if CLIENT then
				LoadedSounds[FileName] = { sound, filter } -- cache the CSoundPatch
			end
		end
	else
		sound = LoadedSounds[FileName][1]
		filter = LoadedSounds[FileName][2]
	end
	if sound then
		if CLIENT then
			sound:Stop() -- it won't play again otherwise
		end
		sound:Play()
	end
	return sound -- useful if you want to stop the sound yourself
end

function util.ToMinutesSeconds(seconds)
	local minutes = math.floor(seconds / 60)
	seconds = seconds - minutes * 60
    return string.format("%02d:%02d", minutes, math.floor(seconds))
end
