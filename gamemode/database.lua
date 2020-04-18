	ModularCombatDB = {}
function ModularCombatDB:databaseCheck()
	if sql.TableExists("modcombat") then
		print("SQL databases exist for Modular Combat")
		return true
	else
		if (!sql.TableExists("modcombat")) then
			local query = "CREATE TABLE modcombat ( SteamID varchar(255) NOT NULL UNIQUE, Char1 mediumtext, Char2 mediumtext, Char3 mediumtext );"
			result = sql.Query(query)
			if result != nil then
				print("[SQL ERROR]: "..sql.LastError())
				return false
			end
		end
		print("Added Modular Combat into SQL DataBase.")
		return true
	end
end

function ModularCombatDB:savePlayerData( ply )
	local sid = ply:SteamID()
	if playerData[sid] != nil then
		local jsons = {}
		for k,v in pairs( playerData[sid] ) do
			jsons[k] = util.TableToJSON(v)
		end
		local feeler = sql.Query("SELECT * FROM modcombat WHERE SteamID='"..sid.."'")
		if feeler == nil then
			local query1 = sql.Query("INSERT INTO modcombat (SteamID) VALUES ('"..sid.."')")
			if query1==false then
				print("SQL ERROR QUERY1="..sql.LastError())
			end
		end
		for k,v in pairs( jsons ) do
			local query2 = sql.Query("UPDATE modcombat SET Char"..k.."='"..v.."' WHERE SteamID='"..sid.."'")
			if query2==false then
				print("SQL ERROR QUERY2="..sql.LastError())
			end
		end
	end
end

function ModularCombatDB:deletePlayer( ply, num )
	if IsValid( ply ) then
		local sid = ply:SteamID()
		local result = sql.Query("UPDATE modcombat SET Char"..tostring( num ).." = NULL WHERE SteamID = '"..sid.."'")
		if result != nil then
			print("RESULT: "..result)
		end
	else
		print("[ERROR] Tried to removed an invalid char from the database with a null player!")
	end
end

function ModularCombatDB:loadPlayer( ply )
	local sid = ply:SteamID()
	playerData[sid] = {}
	local result = sql.Query("SELECT * FROM modcombat WHERE SteamID='"..sid.."'")
	if result == false then
		print("SQL ERROR="..sql.LastError())
		return	
	elseif result != nil then
		if #result > 1 then
			print("[WARN] SteamID: "..ply:SteamID().." ("..ply:Nick()..") has multiple SQL rows!")
			print("[WARN] Only the first row will load!")
		end
		for i = 1, 3 do
			if result[1]["Char"..i] != nil then
				playerData[sid][i] = util.JSONToTable(result[1]["Char"..i])
			end
		end
		net.Start("ModComb_SyncData")
			for i = 1, 3 do
				if playerData[sid][i] != nil then
					net.WriteBool( true )
					net.WriteString( util.TableToJSON( playerData[sid][i] ) )
				else
					net.WriteBool( false )
					net.WriteString( "" )
				end
			end
		net.Send(ply)

	end
	net.Start("ModComb_OpenCharSelection")
	net.Send(ply)
end

util.AddNetworkString("ModComb_OpenCharSelection")
util.AddNetworkString("ModComb_SyncData")
function GM:PlayerAuthed( ply, steamid, _ )
	ModularCombatDB:loadPlayer(ply)
end