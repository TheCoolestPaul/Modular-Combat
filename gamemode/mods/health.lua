health = {
	regenSeconds = 20,
	regenAmount = 1,
	max = 100,
}

function GM:PlayerHurt( ply, att, hp, dt )
	timer.Destroy( "ModCombHPRegen_"..ply:UniqueID() )
	timer.Create( "ModCombHPRegen_"..ply:UniqueID(), ply:GetModHealthRegenTime(), 100 - ply:Health(), function()
		if IsValid( ply ) then
			if ply:Health()>= ply:GetMaxHealth() then
				timer.Destroy( "ModCombHPRegen_"..ply:UniqueID() )
			else
				ply:SetHealth( math.Clamp( ply:Health() + ply:GetModHealthRegenAmount(), 0, ply:GetMaxHealth() ) )
			end
		end
	end )
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

function plyMeta:GetModHealthRegenTime()
	return self.activeCharStats.mods.health.regenSeconds
end

function plyMeta:GetModHealthRegenAmount()
	return self.activeCharStats.mods.health.regenAmount
end
