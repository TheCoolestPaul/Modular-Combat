function tables_exist()
	if sql.TableExists("char_info") then
		print("SQL databases exist for Modular Combat")
		return true
	else
		if (!sql.TableExists("char_info")) then
			query = "CREATE TABLE char_info ( unique_id varchar(255), data mediumtext )"
			result = sql.Query(query)
			if result != nil then
				print("MYSQL: "..sql.LastError())
				return false
			end
		end
		print("Made table char_info")
		return true
	end
end

function savePlayerData()
end

function loadPlayer( ply )
	local sid = ply:SteamID()
	result = sql.Query("SELECT * FROM char_info WHERE unique_id="..sid)
	return result
end

tables_exist()