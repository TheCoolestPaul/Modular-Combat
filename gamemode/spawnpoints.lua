spawnpoints = {
	["players"] = {},
	["monsters"] = {},
	["weapons"] = {},
	["ammo"] = {},
	["drops"] = {},
	["big_monsters"] = {},
}
function AddSpawn( typ, pos, ang )
	typ = string.lower(typ)
	local entClass = "spawnpoint_players"
	if typ == "monsters" then
		entClass = "spawnpoint_monsters"
	elseif typ == "big_monsters" then
		entClass = "spawnpoint_big_monsters"
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
	if spawnpoints[typ] == nil then
		print("ERROR for spawnpoint type ("..typ..")")
	else
		table.insert(spawnpoints[typ], ent)
	end
end

function RemoveSpawn( ent )
	if ent:GetClass() == "spawnpoint_ammo" then
		table.RemoveByValue(spawnpoints.ammo, ent)
	elseif ent:GetClass() == "spawnpoint_drops" then
		table.RemoveByValue(spawnpoints.drops, ent)
	elseif ent:GetClass() == "spawnpoint_monsters" then
		table.RemoveByValue(spawnpoints.monsters, ent)
	elseif ent:GetClass() == "spawnpoint_big_monsters" then
		table.RemoveByValue(spawnpoints.big_monsters, ent)
	elseif ent:GetClass() == "spawnpoint_players" then
		table.RemoveByValue(spawnpoints.players, ent)
	elseif ent:GetClass() == "spawnpoint_weapons" then
		table.RemoveByValue(spawnpoints.weapons, ent)
	end
	ent:Remove()
end

function ClearSpawnData()
	if file.Exists( "modular_comat/map_data/" ..string.lower(game.GetMap()).. ".txt", "DATA" ) then
		file.Delete( "modular_comat/map_data/" ..string.lower(game.GetMap()).. ".txt" )
	end
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
	for k,v in pairs(spawnpoints.big_monsters) do
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
	print("[ModularCombat] Map Manager: All of the spawns were deleted!")
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
	for k, v in pairs(spawnpoints.big_monsters) do
		if IsValid(v) then
			table.insert(data, {
				type = "big_monsters",
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
				if v.type == "monsters" then
					entClass = "spawnpoint_monsters"
				elseif v.type == "big_monsters" then
					entClass = "spawnpoint_big_monsters"
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
				table.insert(spawnpoints[string.lower( v.type )], ent)
			end

            print( "[Modular Combat]: Finished loading spawn data for map "..string.lower(game.GetMap()) )
        end
    else
        print( "[WARNING] There are no spawns set for anything! Use the admin menu (Default: F1 'gm_showhelp') to set them." )
    end
end

hook.Add( "InitPostEntity", "ModComb_LoadInitPostEntity", LoadSpawns )
hook.Add( "PostCleanupMap", "ModComb_LoadPostCleanup", LoadSpawns )
