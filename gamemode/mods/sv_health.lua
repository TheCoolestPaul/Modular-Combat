health = {
	regenSeconds = 20,
	regenAmount = 1,
	max = 100,
}

function GM:PlayerHurt( ply, att, hp, dt )
	local ident = "ModCombHPRegen_"..ply:UniqueID()
	if timer.Exists(ident) then
		timer.Destroy( ident )
	end
	timer.Create( ident, ply:GetModHealthRegenTime(), 100 - ply:Health(), function()
		if IsValid( ply ) then
			if ply:Health() >= ply:GetMaxHealth() then
				timer.Destroy( ident )
			else
				ply:SetHealth( math.Clamp( ply:Health() + ply:GetModHealthRegenAmount(), 0, ply:GetMaxHealth() ) )
			end
		end
	end )
end

function GM:PlayerDeath( ply, inf, att )
	timer.Destroy( "ModCombHPRegen_"..ply:UniqueID() )
	if ply != att then
		if IsValid( att ) and att:IsPlayer() then
			print("player killed player")
		end
	end
	ply:EmitSound("player/pl_pain"..math.random(5,7)..".wav", 100, 100)
end

function plyMeta:GetModHealthRegenTime()
	return self.activeCharStats.mods.health.regenSeconds
end

function plyMeta:GetModHealthRegenAmount()
	return self.activeCharStats.mods.health.regenAmount
end
