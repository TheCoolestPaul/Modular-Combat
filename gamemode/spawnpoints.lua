MonsterSpawns = {}
spawnpoints = {
	players = {},
	monsters = {},
	weapons = {},
	ammo = {},
	drops = {},
}
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
	table.insert(spawnpoints[typ], ent)
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
	table.Empty(MonsterSpawns)
	for k, v in pairs(spawnpoints.players) do
		if IsValid(v) then
			v:Remove()
		end
	end
	for k, v in pairs(spawnpoints.monsters) do
		if IsValid(v) then
			v:Remove()
		end
	end
	for k, v in pairs(spawnpoints.weapons) do
		if IsValid(v) then
			v:Remove()
		end
	end
	for k, v in pairs(spawnpoints.ammo) do
		if IsValid(v) then
			v:Remove()
		end
	end
	for k, v in pairs(spawnpoints.drops) do
		if IsValid(v) then
			v:Remove()
		end
	end
	for k,tab in pairs(spawnpoints) do
		table.Empty(tab)
	end
	print("All of the spawns were deleted!")
end

function SaveSpawns()
    local data = {}
	for k, v in pairs(spawnpoints.players) do
		if IsValid(v) then
			table.insert(data, {
				type = "players",
				pos = v:GetPos(),
				ang = v:GetAngles()
			})
		end
	end
	for k, v in pairs(spawnpoints.monsters) do
		if IsValid(v) then
			table.insert(data, {
				type = "monsters",
				pos = v:GetPos(),
				ang = v:GetAngles()
			})
		end
	end
	for k, v in pairs(spawnpoints.weapons) do
		if IsValid(v) then
			table.insert(data, {
				type = "weapons",
				pos = v:GetPos(),
				ang = v:GetAngles()
			})
		end
	end
	for k, v in pairs(spawnpoints.ammo) do
		if IsValid(v) then
			table.insert(data, {
				type = "ammo",
				pos = v:GetPos(),
				ang = v:GetAngles()
			})
		end
	end
	for k, v in pairs(spawnpoints.drops) do
		if IsValid(v) then
			table.insert(data, {
				type = "drops",
				pos = v:GetPos(),
				ang = v:GetAngles()
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