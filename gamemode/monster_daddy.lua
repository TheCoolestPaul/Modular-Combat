local MaxMonsters = 60 // TODO: mess with this <3
MonsterCount = 0
MonsterSpawns = {}

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

local function spawnAMonster(spawnNum)
	local spawn = MonsterSpawns[spawnNum]
	local monsterClass = SpawnableMonsters[GetRandomWeightedInt(1, #SpawnableMonsters, 4)]
	monster = ents.Create( monsterClass )
	local monsterLevel = math.random( math.max(1, math.random( PlayerAverageLevel - 2 ) ), math.random(PlayerAverageLevel + 5))
	monster:SetNWInt("Level", monsterLevel)
	monster:SetMaxHealth( monster:GetMaxHealth() + ( monster:GetMaxHealth()*( 0.1*monster:GetNWInt("Level", 1) ) ) )
	monster:SetHealth(monster:GetMaxHealth())
	monster:SetPos( spawn:GetPos() )
	monster:SetAngles( spawn:GetAngles() )
	monster:Spawn()
	MonsterCount = MonsterCount + 1
end

local lastSpawnTime = 0
hook.Add( "Think", "MonsterDaddy_SpawnMonster", function()
	if CurTime() < lastSpawnTime or MonsterCount > MaxMonsters or #MonsterSpawns <= 0 then return end
	local pickSpawns = math.Round(#MonsterSpawns/2)
	for i=1,pickSpawns do
		spawnAMonster( math.random(#MonsterSpawns) )
		if MonsterCount >= MaxMonsters then
			print("HIT MAX MONSTERS")
			break
		end
	end
	lastSpawnTime = CurTime() + 5
end )