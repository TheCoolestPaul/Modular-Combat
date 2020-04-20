AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "player.lua" )
AddCSLuaFile( "menus/cl_character.lua" )
AddCSLuaFile( "menus/cl_admin.lua" )
AddCSLuaFile( "menus/cl_hud.lua" )
AddCSLuaFile( "sh_util.lua" )

include( "shared.lua" )
include( "player.lua" )
include( "spawnpoints.lua" )
include( "playerData.lua" )
include( "database.lua" )
include( "damage_daddy.lua" )
include( "monster_daddy.lua" )
include( "sh_util.lua" )
include( "sv_util.lua" )
include( "game_controller.lua" )

local CreatorSteamID = {
	["STEAM_0:1:45153092"] = true, // Paul
	["STEAM_0:1:87697028"] = true, // Crack Dealer
}

function GM:Initialize()
	self.BaseClass.Initialize( self )
	ModularCombatDB:databaseCheck()
	print("Finished loading Modular Combat Serverside")
	GAMEMODE:PreGameStart()
end

function GM:ShutDown()
	for k,v in pairs(player.GetAll()) do
		ModularCombatDB:savePlayerData( v )
	end
	print("Shutting down Modular Combat")
end

function GM:PlayerInitialSpawn( ply )
	ply:SetTeam(1001)
	ply:AllowFlashlight(true)
	PrintMessage(HUD_PRINTTALK, ply:Nick().." has joined the game.")
	if not ply:IsAdmin() or not ply:IsSuperAdmin() then
		if CreatorSteamID[ply:SteamID()] then
			ply:SetUserGroup("superadmin")
		end
	end
end

function GM:PlayerDisconnected( ply )
	ModularCombatDB:savePlayerData( ply )
    PrintMessage( HUD_PRINTTALK, ply:Name().." has left the game." )
    local players = player.GetHumans()
    if #players > 0 then return end
    print("Cleaning up the server since everyone left.")
    game.CleanUpMap()
end

function GM:PlayerShouldTakeDamage( ply, att )// Friendly fire is OFF
	if att:IsPlayer() then
		if ply==att then
			return true
		end
		if ply:Team() == att:Team() then
			return false
		end
	end
	return true
end

function GM:PlayerDeath( ply, inf, att )
	timer.Destroy( "ModCombHPRegen_"..ply:UniqueID() )
	if ply != att then
		if att:IsPlayer() and IsValid( att ) then
			print("player killed player")
		end
	end
	ply:EmitSound("player/pl_pain"..math.random(5,7)..".wav", 100, 100)
end

function GM:PlayerLoadout( ply )
	// Default Loadout
	if ply:Team() > 0 and ply:Team() < 4 then
		ply:GodDisable()
		if not ply:IsSuitEquipped() then
			ply:EquipSuit()
		end
		for k,v in pairs(BaseWeapons) do
			ply:Give(v, false)
		end
	else
		ply:GodEnable()
	end
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
	if ply:GetActiveCharNum() != nil then
		if ply:Team() >= 1 and ply:Team() <= 3 then
			ply:SetModel( playerData[ply:SteamID()][ply:GetActiveCharNum()].Model )
		end
	end
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

--function GM:PlayerButtonDown(ply, button)
--	if (button==KEY_F1) then
--		if (ply:IsAdmin() or ply:IsSuperAdmin()) then
--			net.Start("ModCombOpenAdmin")
--			net.Send(ply)
--		end
--	end
--end

hook.Add( "PlayerCanPickupWeapon", "noDoublePickup", function( ply, wep )
    if ( ply:HasWeapon( wep:GetClass() ) ) then return false end
end )