MonsterSpawns = {}
function AddSpawn( typ, pos, ang )
	local entClass = "spawnpoint_players"
	local monster = false
	if typ == "monsters" then
		entClass = "spawnpoint_monsters"
		monster = true
	elseif typ == "weapons" then
		entClass = "spawnpoint_weapons"
	elseif typ == "ammo" then
		entClass = "spawnpoint_ammo"
	elseif typ == "drops" then
		entClass = "spawnpoint_drops"
	end
	local ent = ents.Create(entClass)
	if not ent:IsValid() then return end
	ent:SetPos(pos)
	ent:SetAngles(ang)
	ent:Spawn()
	ent:DropToFloor()
	if monster then
		table.insert(MonsterSpawns, ent)
	end
end
util.AddNetworkString( "ModComb_AddSpawner" )
net.Receive( "ModComb_AddSpawner", function( len, ply )
	if not ply:IsAdmin() or not ply:IsSuperAdmin() then return end
	local typ = net.ReadString()
	AddSpawn( typ, net.ReadVector(), net.ReadAngle() )
	ply:ChatPrint( "Made a "..typ.." spawner")
end )

util.AddNetworkString( "ModComb_SaveSpawns" )
net.Receive( "ModComb_SaveSpawns", function( len, ply )
	if not ply:IsAdmin() or not ply:IsSuperAdmin() then return end
	SaveSpawns()
	ply:ChatPrint( "Saved all spawns." )
end )

util.AddNetworkString( "ModComb_ClearSpawns" )
net.Receive( "ModComb_ClearSpawns", function( len, ply)
	if not ply:IsAdmin() or not ply:IsSuperAdmin() then return end
	ClearSpawnData()
	ply:ChatPrint( "Cleared all spawns." )
end )

function ClearSpawnData()
	if file.Exists( "modular_comat/map_data/" ..string.lower(game.GetMap()).. ".txt", "DATA" ) then
		file.Delete( "modular_comat/map_data/" ..string.lower(game.GetMap()).. ".txt" )
	end
	for k, v in pairs(spawnpointsManager.spawnpoints.Players) do
		if IsValid(k) then
			k:Remove()
		end
	end
	for k, v in pairs(spawnpointsManager.spawnpoints.Monsters) do
		if IsValid(k) then
			k:Remove()
		end
	end
	for k, v in pairs(spawnpointsManager.spawnpoints.Weapons) do
		if IsValid(k) then
			k:Remove()
		end
	end
	for k, v in pairs(spawnpointsManager.spawnpoints.Ammo) do
		if IsValid(k) then
			k:Remove()
		end
	end
	for k, v in pairs(spawnpointsManager.spawnpoints.Drops) do
		if IsValid(k) then
			k:Remove()
		end
	end
	print("All of the spawns were deleted!")
end

function SaveSpawns()
    local data = {}
	for k, v in pairs(spawnpointsManager.spawnpoints.Players) do
		if IsValid(k) then
			table.insert(data, {
				type = "players",
				pos = k:GetPos(),
				ang = k:GetAngles()
			})
		end
	end
	for k, v in pairs(spawnpointsManager.spawnpoints.Monsters) do
		if IsValid(k) then
			table.insert(data, {
				type = "monsters",
				pos = k:GetPos(),
				ang = k:GetAngles()
			})
		end
	end
	for k, v in pairs(spawnpointsManager.spawnpoints.Weapons) do
		if IsValid(k) then
			table.insert(data, {
				type = "weapons",
				pos = k:GetPos(),
				ang = k:GetAngles()
			})
		end
	end
	for k, v in pairs(spawnpointsManager.spawnpoints.Ammo) do
		if IsValid(k) then
			table.insert(data, {
				type = "ammo",
				pos = k:GetPos(),
				ang = k:GetAngles()
			})
		end
	end
	for k, v in pairs(spawnpointsManager.spawnpoints.Drops) do
		if IsValid(k) then
			table.insert(data, {
				type = "drops",
				pos = k:GetPos(),
				ang = k:GetAngles()
			})
		end
	end

	if not file.Exists( "modular_comat", "DATA")  then
		file.CreateDir( "modular_comat" )
	end
	if not file.Exists( "modular_comat/map_data", "DATA" ) then
		file.CreateDir( "modular_comat/map_data" )
	end
	if table.Count(data) > 0 then
		file.Write( "modular_comat/map_data/" .. string.lower(game.GetMap()) .. ".txt", util.TableToJSON(data) )
	end
	print( "Saved spawns for map "..string.lower( game.GetMap() ) )
end

function LoadSpawns()
	if file.Exists( "modular_comat/map_data/" .. string.lower(game.GetMap()) .. ".txt", "DATA" ) then
		local data = file.Read( "modular_comat/map_data/" .. string.lower(game.GetMap()) .. ".txt", "DATA" )
		data = util.JSONToTable(data)

		if data and table.Count(data) > 0 then
			for k, v in pairs(data) do
				local entClass = "spawnpoint_players"
				local monster = false
				if v.type == "monsters" then
					entClass = "spawnpoint_monsters"
					monster = true
				elseif v.type == "weapons" then
					entClass = "spawnpoint_weapons"
				elseif v.type == "ammo" then
					entClass = "spawnpoint_ammo"
				elseif v.type == "drops" then
					entClass = "spawnpoint_drops"
				end
				local ent = ents.Create(entClass)
				ent:SetPos(v.pos)
				ent:SetAngles(v.ang)
				ent:Spawn()
				ent:Activate()
				local phys = ent:GetPhysicsObject()

				if (phys:IsValid()) then
					phys:Wake()
					phys:EnableMotion(false)
				end

				if monster then
					table.insert(MonsterSpawns, ent)
				end
			end

            print( "[Modular Combat]: Finished loading spawn data for map "..string.lower(game.GetMap()) )
        end
    else
        print( "[WARNING] There are no spawns set for anything! Use the admin menu (Default: F1 'gm_showhelp') to set them." )
    end
end

hook.Add( "InitPostEntity", "ModComb_LoadInitPostEntity", LoadSpawns )
hook.Add( "PostCleanupMap", "ModComb_LoadPostCleanup", LoadSpawns )