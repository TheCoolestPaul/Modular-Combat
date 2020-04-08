PlayerSpawns = {}
MonsterSpawns = {}

function AddSpawn( typ, pos, ang )
	local entClass = "spawnpoint_players"
	if typ == "monsters" then
		entClass = "spawnpoint_monsters"
	elseif typ == "weapons" then
		entClass = "spawnpoint_weapons"
	elseif typ == "ammo"
		entClass = "spawnpoint_ammo"
	elseif typ == "drops"
		entClass = "spawnpoint_drops"
	end
	local crate = ents.Create(entClass)
	if not crate:IsValid() then return end
	crate:SetPos(pos)
	crate:SetAngles(ang)
	crate:Spawn()
	crate:DropToFloor()
	PlayerSpawns[crate] = true
end
util.AddNetworkString( "ModComb_AddSpawner" )
net.Receive( "ModComb_AddSpawner", function( len, ply )
	if not ply:IsAdmin() or not ply:IsSuperAdmin() then return end
	AddSpawn( net.ReadString(), net.ReadVector(), net.ReadAngle() )
end )

util.AddNetworkString( "ModComb_SaveSpawns" )
net.Receive( "ModComb_SaveSpawns", function( len, ply )
	if not ply:IsAdmin() or not ply:IsSuperAdmin() then return end
	SaveSpawns()
end )

function ClearSpawnData()
	if file.Exists("modular_comat/map_data/" .. string.lower(game.GetMap()) .. ".txt", "DATA") then
		file.Delete("modular_comat/map_data/" .. string.lower(game.GetMap()) .. ".txt")
	end
	for k, v in pairs(ents.FindByClass("spawnpoint_players")) do
		if IsValid(v) then
			v:Remove()
		end
	end
	for k, v in pairs(ents.FindByClass("spawnpoint_monsters")) do
		if IsValid(v) then
			v:Remove()
		end
	end
	for k, v in pairs(ents.FindByClass("spawnpoint_weapons")) do
		if IsValid(v) then
			v:Remove()
		end
	end
	for k, v in pairs(ents.FindByClass("spawnpoint_ammo")) do
		if IsValid(v) then
			v:Remove()
		end
	end
	for k, v in pairs(ents.FindByClass("spawnpoint_drops")) do
		if IsValid(v) then
			v:Remove()
		end
	end
end

function SaveSpawns()
    local data = {}

	for k, v in pairs(ents.FindByClass("spawnpoint_players")) do
		if IsValid(v) then
			table.insert(data, {
				type = "players",
				pos = v:GetPos(),
				ang = v:GetAngles()
			})
		end
	end
	for k, v in pairs(ents.FindByClass("spawnpoint_monsters")) do
		if IsValid(v) then
			table.insert(data, {
				type = "monsters",
				pos = v:GetPos(),
				ang = v:GetAngles()
			})
		end
	end
	for k, v in pairs(ents.FindByClass("spawnpoint_weapons")) do
		if IsValid(v) then
			table.insert(data, {
				type = "weapons",
				pos = v:GetPos(),
				ang = v:GetAngles()
			})
		end
	end
	for k, v in pairs(ents.FindByClass("spawnpoint_ammo")) do
		if IsValid(v) then
			table.insert(data, {
				type = "ammo",
				pos = v:GetPos(),
				ang = v:GetAngles()
			})
		end
	end
	for k, v in pairs(ents.FindByClass("spawnpoint_drops")) do
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
end

function LoadSpawns()
	if file.Exists( "modular_comat/map_data/" .. string.lower(game.GetMap()) .. ".txt", "DATA" ) then
		local data = file.Read( "modular_comat/map_data/" .. string.lower(game.GetMap()) .. ".txt", "DATA" )
		data = util.JSONToTable(data)

		if data and table.Count(data) > 0 then
			for k, v in pairs(data) do
				local entClass = "spawnpoint_players"
				if v.type == "monsters" then
					entClass = "spawnpoint_monsters"
				elseif v.type == "weapons" then
					entClass = "spawnpoint_weapons"
				elseif v.type == "ammo"
					entClass = "spawnpoint_ammo"
				elseif v.type == "drops"
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
			end

            print( "[Modular Combat]: Finished loading spawn data for map "..string.lower(game.GetMap()) )
        end
    else
        print( "[WARNING] There are no spawns set for anything! Use the admin menu (Default: F1 'gm_showhelp') to set them." )
    end
end

hook.Add( "InitPostEntity", "ModComb_LoadInitPostEntity", LoadSpawns )
hook.Add( "PostCleanupMap", "ModComb_LoadPostCleanup", LoadSpawns )