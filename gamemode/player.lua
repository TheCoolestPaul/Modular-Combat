local plyMeta = FindMetaTable("Player")

plyMeta.activeCharStats = {
	mods = {
		healthRegen = {
			seconds = 20,
			amount = 1,
		},
		armorRegen = {
			seconds = 20,
			amount = 0,
		},
		maxAmmo = {
			["Pistol"] = 180,
			["357"] = 36,
			["SMG1"] = 180,
			["AR2"] = 120, // Pulse Rifle
			["Buckshot"] = 24, 
			["XBowBolt"] = 15, // Crossbow
			["Grenade"] = 3,
			["SMG1_Grenade"] = 3,
			["slam"] = 3,
			["RPG_Round"] = 3,
			["AR2AltFire"] = 3, // Pulse Rifle Ball
		},
	},
	EXP = 0,
	EXPNext = 100,
	Level = 1,
}
plyMeta.charStats = {
	--[[
	[1] = {
		Level = 1,
		Name = "N/A",
		Team = 1001,
		Model = "",
		mods = {},
	}
	]]
}

plyMeta.ActiveChar = 0
function plyMeta:GetActiveChar()
	return self.ActiveChar
end
function plyMeta:SetActiveChar( num )
	self.ActiveChar = num
end

function plyMeta:GetModHealthRegenTime()
	return self.activeCharStats.mods.healthRegen.seconds
end

function plyMeta:GetModHealthRegenAmount()
	return self.activeCharStats.mods.healthRegen.amount
end

function plyMeta:GetModArmorRegenTime()
	return self.activeCharStats.mods.armorRegen.seconds
end

function plyMeta:GetModArmorRegenAmount()
	return self.activeCharStats.mods.armorRegen.amount
end

function plyMeta:GetModLevel()
	return self.activeCharStats.Level
end

function plyMeta:GetModExpNext()
	return self.activeCharStats.EXPNext
end

function plyMeta:GetModExp()
	return self.activeCharStats.EXP
end

if SERVER then
	function plyMeta:LevelUp()
		self.activeCharStats.Level = self.activeCharStats.Level + 1
	end
	function plyMeta:AddModExp( expNum )
		self.activeCharStats.EXP = self.activeCharStats.EXP + expNum
		if ( self.activeCharStats.EXP >= self.activeCharStats.EXPNext ) then
			self:LevelUp()
			self.activeCharStats.EXP = self.activeCharStats.EXP - self.activeCharStats.EXPNext
			self.activeCharStats.EXPNext =  100 * self.activeCharStats.Level
		end
		self:SetNWInt("EXP", self.activeCharStats.EXP)
		self:SetNWInt("Level", self.activeCharStats.Level)
		self:SetNWInt("EXPNext", self.activeCharStats.EXPNext)
	end
	function plyMeta:ClearEXP()
		self.activeCharStats.EXP = 0
	end
	function plyMeta:RemoveModExp( expNum )
		self.activeCharStats.EXP = math.max(0,  self.activeCharStats.EXP - expNum)
	end
	function plyMeta:SetModCombatTeam( teamNum )
		if not ( teamNum >= 1 and teamNum <= 3 ) then // Eliminate out of bound options
			return false
		end

		PrintMessage(HUD_PRINTTALK, self:Nick().." has joined team "..team.GetName(teamNum))
		self:SetTeam( teamNum )

		if teamNum == 1 then// Combine Team
			self:SetPlayerColor( Vector( 0.6,0,0 ) )
		elseif teamNum == 2 then// Resistance
			self:SetPlayerColor( Vector( 0,0.5,0 ) )
		else// Aperature
			self:SetPlayerColor( Vector( 0,0.5,1.0 ) )
		end
		self:SetNWBool("ShouldShowHUD", true)
		self:Spawn()
		return true
	end

	util.AddNetworkString( "FinsihedCharCreation" )
	net.Receive( "FinsihedCharCreation", function( len, ply )
		local teamNum = net.ReadInt(3)
		local model = net.ReadString()
		//local charName = net.ReadString()
		local charNum = net.ReadInt(3)

		ply.charStats[charNum] = {}
		ply.charStats[charNum].Team = teamNum
		ply.charStats[charNum].Model = model
		ply:SetActiveChar( charNum )
		ply:SetModCombatTeam( teamNum )
		ply:SetModel( model )

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
end