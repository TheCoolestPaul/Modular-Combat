AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function GM:PlayerConnect(name, ip)
	PrintMessage(HUD_PRINTTALK, name.." has joined the game.")
end

function GM:PlayerInitialSpawn( player )
end

function GM:PlayerAuthed( player, steamid, uniqueid )
end