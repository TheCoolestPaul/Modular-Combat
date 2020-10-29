local plyMeta = FindMetaTable("Player")
AccessorFunc(plyMeta, "active_char", "ActiveCharNum", FORCE_NUMBER)
AccessorFunc(plyMeta, "modcombat_armor", "ModArmor", FORCE_NUMBER)

if SERVER then
	playerData = {
		--[[ 
		["STEAMID"] = {
			[charNum] = {
				Level = 1,
				EXP = 0,
				AvaMods = 0,
				Name = charName,
				Team = teamNum,
				Model = model,
				mods = {},
			},
		},
		]]--
	}
	function AddModExp( ply, expNum )
		if IsValid( ply ) then
			local newEXP = playerData[ply:SteamID()][ply:GetActiveCharNum()].EXP + expNum
			if ( newEXP >= playerData[ply:SteamID()][ply:GetActiveCharNum()].Level*100 ) then
				playerData[ply:SteamID()][ply:GetActiveCharNum()].EXP = newEXP - playerData[ply:SteamID()][ply:GetActiveCharNum()].Level*100
				playerData[ply:SteamID()][ply:GetActiveCharNum()].Level = playerData[ply:SteamID()][ply:GetActiveCharNum()].Level + 1
				playerData[ply:SteamID()][ply:GetActiveCharNum()].AvaMods = playerData[ply:SteamID()][ply:GetActiveCharNum()].AvaMods + 5
				ply:SetNWInt( "Level", playerData[ply:SteamID()][ply:GetActiveCharNum()].Level )
				ply:SetNWInt( "EXPNext", playerData[ply:SteamID()][ply:GetActiveCharNum()].Level*100 )
			else
				playerData[ply:SteamID()][ply:GetActiveCharNum()].EXP = newEXP
			end
			ply:SetNWInt( "EXP", playerData[ply:SteamID()][ply:GetActiveCharNum()].EXP )
		end
	end
	function plyMeta:SetModCombatTeam( teamNum )
		if not ( teamNum >= 1 and teamNum <= 3 ) then
			return false
		end

		PrintMessage(HUD_PRINTTALK, self:Nick().." has joined team "..team.GetName(teamNum))
		self:SetTeam( teamNum )

		if teamNum == 1 then// Combine Team
			self:SetPlayerColor( Vector( 0.6,0,0 ) )
		elseif teamNum == 2 then// Resistance
			self:SetPlayerColor( Vector( 0,0.5,0 ) )
		elseif teamNum == 3 then
			self:SetPlayerColor( Vector( 0,0.5,1.0 ) )
		end
		return true
	end

	util.AddNetworkString( "PickedChar" )
	net.Receive( "PickedChar", function( len, ply )
		local teamNum = net.ReadInt( 11 )
		local charNum = net.ReadInt( 3 )
		ply:SetActiveCharNum( charNum )
		ply:SetModCombatTeam( teamNum )
		ply:SetNWInt( "Level", playerData[ply:SteamID()][ply:GetActiveCharNum()].Level )
		ply:SetNWInt( "EXPNext", playerData[ply:SteamID()][ply:GetActiveCharNum()].Level*100 )
		ply:SetNWInt( "EXP", playerData[ply:SteamID()][ply:GetActiveCharNum()].EXP )
		ply:SetNWBool("ShouldShowHUD", true)
		ply:Spawn()
	end )

	util.AddNetworkString( "FinsihedCharCreation" )
	net.Receive( "FinsihedCharCreation", function( len, ply )
		local teamNum = net.ReadInt(3)
		local model = net.ReadString()
		local charName = net.ReadString()
		local charNum = net.ReadInt(3)
		local sid = ply:SteamID()
		
		if playerData[sid] == nil then
			playerData[sid] = {}
		end
		playerData[sid][charNum] = {}
		playerData[sid][charNum].Level = 1
		playerData[sid][charNum].EXP = 0
		playerData[sid][charNum].AvaMods = 0
		playerData[sid][charNum].Name = charName
		playerData[sid][charNum].Team = teamNum
		playerData[sid][charNum].Model = model
		playerData[sid][charNum].mods = {}
		ply:SetActiveCharNum( charNum )
		ply:SetModCombatTeam( teamNum )
		ply:SetModel( model )
		ply:SetNWBool("ShouldShowHUD", true)
		ply:Spawn()

	end )

	util.AddNetworkString( "ModCombAdminGod" )
	net.Receive( "ModCombAdminGod", function( len, ply ) 
		if not ply:IsAdmin() or not ply:IsSuperAdmin() then return end
		if ply:HasGodMode() then
			ply:GodDisable()
			ply:ChatPrint( "Disabled Godmode" )
		else
			ply:GodEnable()
			ply:ChatPrint( "Enabled Godmode" )
		end
	end )

	util.AddNetworkString( "ModCombAdminPlayerESP" )
	net.Receive( "ModCombAdminPlayerESP", function( len, ply ) 
		if not ply:IsAdmin() or not ply:IsSuperAdmin() then return end
		if ply:GetNWBool("ModCombAdminPlayerESP", false) then
			ply:SetNWBool("ModCombAdminPlayerESP", false)
			ply:ChatPrint( "Disabled Player ESP" )
		else
			ply:SetNWBool("ModCombAdminPlayerESP", true)
			ply:ChatPrint( "Enabled Player ESP" )
		end
	end )

	util.AddNetworkString( "ModCombAdminSpawnersESP" )
	net.Receive( "ModCombAdminSpawnersESP", function( len, ply ) 
		if not ply:IsAdmin() or not ply:IsSuperAdmin() then return end
		if ply:GetNWBool("ModCombAdminSpawnersESP", false) then
			ply:SetNWBool("ModCombAdminSpawnersESP", false)
			ply:ChatPrint( "Disabled Spawner ESP" )
		else
			ply:SetNWBool("ModCombAdminSpawnersESP", true)
			ply:ChatPrint( "Enabled Spawner ESP" )
		end
	end )

	util.AddNetworkString( "ModCombGiveSpawnTool" )
	net.Receive( "ModCombGiveSpawnTool", function( len, ply )
		if not ply:IsAdmin() or not ply:IsSuperAdmin() then return end
		if ply:HasWeapon( "weapon_spawnpoint_tool" ) then return end
		ply:Give( "weapon_spawnpoint_tool" )
	end )
end