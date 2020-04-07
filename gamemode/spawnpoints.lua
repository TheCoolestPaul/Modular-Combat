PlayerSpawns = {}
MonsterSpawns = {}

function AddSpawnPlayers( pos, ang )
	local crate = ents.Create("spawnpoint_players")
	if not crate:IsValid() then return end
	crate:SetPos(pos)
	crate:SetAngles(ang)
	crate:Spawn()
	crate:DropToFloor()
	PlayerSpawns[crate] = true
end
hook.Add("ModComb_AddSpawnPlayers", "AddSpawnPlayers", AddSpawnPlayers)
util.AddNetworkString("ModComb_AddSpawnPlayers")
net.Receive("ModComb_AddSpawnPlayers", function()
	AddSpawnPlayers(net.ReadVector(), net.ReadAngle())
end)

function AddSpawnMonsters( pos, ang )
	local crate = ents.Create("spawnpoint_monsters")
	if not crate:IsValid() then return end
	crate:SetPos(pos)
	crate:SetAngles(ang)
	crate:Spawn()
	crate:DropToFloor()
	MonsterSpawns[crate] = true
end
hook.Add("ModComb_AddSpawnMonsters", "AddSpawnMonsters", AddSpawnMonsters)
util.AddNetworkString("ModComb_AddSpawnMonsters")
net.Receive("ModComb_AddSpawnMonsters", function()
	AddSpawnMonsters(net.ReadVector(), net.ReadAngle())
end)