DMGTable = {}

function ClearDamageTable()
	DMGTable = {}
end

hook.Add( "PostEntityTakeDamage", "Damage_Daddy_TakeDamage", function( ent, dmg, took )
	if took and not ent:IsPlayer() then
		att = dmg:GetAttacker()
		if DMGTable[ent] != nil then
			if DMGTable[ent][att] != nil then
				DMGTable[ent][att] = DMGTable[ent][att] + dmg:GetDamage()
			else
				DMGTable[ent][att] = dmg:GetDamage()
			end
		else
			DMGTable[ent] = {}
			DMGTable[ent][att] = dmg:GetDamage()
		end
	end
end )

hook.Add( "OnNPCKilled", "Damage_Daddy_Killed", function( npc, att, _ )
	if DMGTable[npc] then
		local totalDamage = 0
		for ply,dmg in pairs( DMGTable[npc] ) do
			totalDamage = dmg + totalDamage
		end
		for ent,dmg in pairs( DMGTable[npc] ) do
			if IsValid( ent ) and ent:IsPlayer() then
				local dmgPerc = dmg/totalDamage
				local baseEXP = GetMonsterBaseEXP( npc:GetClass() )
				local monsterLevel = npc:GetNWInt("Level", 1)
				if baseEXP then
					baseEXP = baseEXP + (baseEXP * (0.2*monsterLevel ) )
					local expTotal = math.Max(0, math.Round( ( dmgPerc ) * baseEXP ) )
					AddModExp( ent, expTotal )
					ent:ChatPrint("You dealt "..math.Round( dmgPerc*100 ).."% of the damage to "..npc:GetClass().." LVL "..monsterLevel.." and earned "..expTotal.." exp")
				else
					print("error finding EXP for "..npc:GetClass())
				end
			end
		end
	elseif att:IsPlayer() then
		local baseEXP = GetMonsterBaseEXP( npc:GetClass() )
		local monsterLevel = npc:GetNWInt("Level", 1)
		if baseEXP then
			baseEXP = math.Round( baseEXP + (baseEXP * (0.2*monsterLevel ) ) )
			AddModExp( att, baseEXP )
			att:ChatPrint("You dealt 100% of the damage to "..npc:GetClass().." LVL "..monsterLevel.." and earned "..baseEXP.." exp")
		else
			print("error finding EXP for "..npc:GetClass())
		end
	end
	MonsterCount = math.max(MonsterCount - 1, 0)
	npc:Remove()
end )