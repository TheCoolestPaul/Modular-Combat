local MaxMonsters = 90 -- TODO: mess with this <3
MonsterCount = 0
spawnpoints = {
	players = {},
	monsters = {},
	weapons = {},
	ammo = {},
	drops = {},
}

local function SetRandomTargetForNPC( npc )
	if ( npc:IsNPC() ) then
		if ( !IsValid(npc:GetEnemy()) ) then
			local _allPlayers = player.GetAll()
			local WINNER = math.random( 1, #_allPlayers )
			timer.Simple(0.15, function()
				local ply = _allPlayers[WINNER]
				if ( !npc:IsValid() or !ply:IsValid() ) then return end
				npc:SetEnemy( ply )
				npc:UpdateEnemyMemory( ply, ply:GetPos() )
				npc:SetSchedule( SCHED_SHOOT_ENEMY_COVER )
			end)
		end
	end
end

local function randomMonsterSpawner()
	local pickedSpawner = spawnpoints.monsters[math.random(#spawnpoints.monsters)]
	local shits = ents.FindInSphere(pickedSpawner:GetPos(), 2000)
	for k,ent in pairs(shits) do
		if ent:IsPlayer() then
			return spawnpoints.monsters[math.random(#spawnpoints.monsters)] -- picks a dif spawn if player is near
		end
	end
	return pickedSpawner
end

local function spawnAMonster(spawnNum)
	local spawn = randomMonsterSpawner()
	local monsterClass = SpawnableMonsters[GetRandomWeightedInt(1, #SpawnableMonsters, 4)]
	monster = ents.Create( monsterClass )
	local monsterLevel = math.random( math.max(1, math.random( PlayerAverageLevel - 2 ) ), math.random(PlayerAverageLevel + 5))
	monster:SetNWInt("Level", monsterLevel)
	monster:SetMaxHealth( monster:GetMaxHealth() + ( monster:GetMaxHealth()*( 0.1*monster:GetNWInt("Level", 1) ) ) )
	monster:SetHealth(monster:GetMaxHealth())
	monster:SetPos( Vector( spawn:GetPos().x, spawn:GetPos().y, spawn:GetPos().z + 10 ) )
	if monsterClass == "npc_vortigaunt" then
		monster:AddRelationship("player D_HT 99")
	end
	for k,v in pairs( MonsterXP ) do
		monster:AddRelationship(v[1].." D_LI 99")
	end
	monster:Spawn()
	MonsterCount = MonsterCount + 1
end

local lastSpawnTime = 0
hook.Add( "Think", "MonsterDaddy_SpawnMonster", function()
	if CurTime() < lastSpawnTime or MonsterCount > MaxMonsters or #spawnpoints.monsters <= 0 then return end
	if not GetGlobalBool( "InRound", false ) then return end
	local pickSpawns = math.Round(#spawnpoints.monsters/2)
	for i=1,pickSpawns do
		spawnAMonster()
		if MonsterCount >= MaxMonsters then
			break
		end
	end
	lastSpawnTime = CurTime() + 5
end )