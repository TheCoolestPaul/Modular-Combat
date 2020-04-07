AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "player.lua" )

include( "shared.lua" )
include( "player.lua" )
include( "spawnpoints.lua" )

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

function GM:PlayerShouldTakeDamage( ply, att )// Friendly fire is OFF
	if att:IsPlayer() then
		if ply:Team() == att:Team() then
			return false
		end
	end
	return true
end

function GM:PlayerHurt( ply, att, hp, dt )
	timer.Destroy( "ModCombHPRegen_"..ply:UniqueID() )
	timer.Create( "ModCombHPRegen_"..ply:UniqueID(), ply:GetModHealthRegenTime(), 100 - ply:Health(), function()
		ply:SetHealth( ply:Health() + ply:GetModHealthRegenAmount() )
	end )
end

function GM:PlayerDeath( ply, inf, att )
	timer.Destroy( "ModCombHPRegen_"..ply:UniqueID() )
	if ply != att then
		if att:IsPlayer() and IsValid( att ) then
			if ply.LastHitGroup() and ply.LastHitGroup() == HITGROUP_HEAD then
			else
			end
		end
	end
	ply:EmitSound("player/pl_pain"..math.random(5,7)..".wav", 100, 100)
end

function GM:PlayerSelectSpawn( ply )
	local spawns = ents.FindByClass("spawnpoint_players")
	if #spawns<=0 then
		print("[WARNING] There are no player spawns set! Use the admin menu (Default: F1 'gm_showhelp') to set them.")
		return 
	end
	local i = math.random(#spawns)
	return spawns[i]
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

util.AddNetworkString( "PickedChar" )
net.Receive( "PickedChar", function( len, ply )
	local teamNum = net.ReadInt( 11 )
	local charNum = net.ReadInt( 3 )
	ply:SetModCombatTeam( teamNum )
end )