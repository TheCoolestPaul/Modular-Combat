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
		}
	},
	EXP = 0,
	EXPNext = 100,
	Level = 1,
	Playing = false,
}
plyMeta.charStats = {
	[1] = {
		Level = 1,
		Name = "N/A",
		Team = 1001,
		model = "",
	},
	[2] = {
		Level = 1,
		Name = "N/A",
		Team = 1001,
		model = "",
	},
	[3] = {
		Level = 1,
		Name = "N/A",
		Team = 1001,
		model = "",
	},
}

function plyMeta:IsPlayingGame()
	return self.activeCharStats.Playing
end

function plyMeta:SetPlaying(bool)
	self.activeCharStats.Playing = bool
	self:SetNWBool("IsPlayingGame", bool)
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
	function plyMeta:AddModExp( expNum )
		self.activeCharStats.EXP = self.activeCharStats.EXP + expNum
	end
	function plyMeta:ClearEXP()
		self.activeCharStats.EXP = 0
	end
	function plyMeta:RemoveModExp( expNum )
		self.activeCharStats.EXP = math.max(0,  self.activeCharStats.EXP - expNum)
	end
	function plyMeta:SetModCombatTeam( teamNum )
		if ( teamNum < 1 or teamNum > 3 ) then // Eliminate out of bound options
			return false
		end

		PrintMessage(HUD_PRINTTALK, self:Nick().." has joined team "..team.GetName(teamNum))
		self:SetTeam( teamNum )

		if not self:IsSuitEquipped() then
			self:EquipSuit()
		end
		for k,v in pairs(BaseWeapons) do
			self:Give(v, false)
		end

		if teamNum == 1 then// Combine Team
			self:SetPlayerColor( Vector( 0.6,0,0 ) )
		elseif teamNum == 2 then// Resistance
			self:SetPlayerColor( Vector( 0,0.5,0 ) )
		else// Aperature
			self:SetPlayerColor( Vector( 0,0.5,1.0 ) )
		end
		self:SetPlaying(true)
		return true
	end

	util.AddNetworkString( "FinsihedCharCreation" )
	net.Receive( "FinsihedCharCreation", function( len, ply )
		local teamNum = net.ReadInt(3)
		local model = net.ReadString()
		local charNum = net.ReadInt(3)
		ply:SetModCombatTeam(teamNum)
		ply.charStats[charNum].team = teamNum
		ply.charStats[charNum].model = model
	end )
end