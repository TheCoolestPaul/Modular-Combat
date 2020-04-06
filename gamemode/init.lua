AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )
include( "player.lua" )

function GM:PlayerInitialSpawn( ply )
	PrintMessage(HUD_PRINTTALK, ply:Nick().." has joined the game.")
end