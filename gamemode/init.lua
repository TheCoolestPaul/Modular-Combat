AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "menus/admin_menu/cl_init.lua" )

include( "shared.lua" )
include( "player.lua" )

local CreatorSteamID = {
	["STEAM_0:1:45153092"] = true, // Paul
	["STEAM_0:1:87697028"] = true, // Crack Dealer
}

function GM:PlayerInitialSpawn( ply )
	ply:SetTeam(1001)
	PrintMessage(HUD_PRINTTALK, ply:Nick().." has joined the game.")
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		print(ply:Nick().." is an admin.")
	else
		if CreatorSteamID[ply:SteamID()] then
			ply:SetUserGroup("superadmin")
		end
	end
end

function GM:PlayerSetModel( ply )
	ply:SetModel("models/player/monk.mdl")
end

util.AddNetworkString("ModCombOpenAdmin")
util.AddNetworkString("ModCombAdminTeamSet")
net.Receive("ModCombAdminTeamSet", function(len, ply)
	local teamNum = net.ReadInt(11)
	local entityIndex = net.ReadInt(11)
	if ents.GetByIndex(entityIndex):IsPlayer() then
		ents.GetByIndex(entityIndex):SetModCombatTeam(teamNum)
	end
end)

function GM:PlayerButtonDown(ply, button)
	if (button==KEY_F1) then
		if (ply:IsAdmin() or ply:IsSuperAdmin()) then
			net.Start("ModCombOpenAdmin")
			net.Send(ply)
		end
	end
end