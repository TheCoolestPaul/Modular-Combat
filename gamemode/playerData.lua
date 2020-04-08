util.AddNetworkString("ModComb_OpenCharSelection")
hook.Add("PlayerInitialSpawn","FullLoadSetup",function(ply) // https://wiki.facepunch.com/gmod/GM:PlayerInitialSpawn
    hook.Add("SetupMove",ply,function(self,ply,_,cmd)
        if self == ply and not cmd:IsForced() then hook.Run("PlayerFullLoad",self) hook.Remove("SetupMove",self) end
    end)
end)

hook.Add("PlayerFullLoad", "PlayerFullyLoaded", function( ply )
	print("Getting "..ply:Nick().." from the database.")
	local result = loadPlayer(ply) // Returns raw SQL result
	if  result != nil and result != false then
		// load char info
		print("Got "..ply:Nick().." from the database")
	elseif result == nil then
		print("SQL ERROR: "..sql.LastError())
	end
	net.Start("ModComb_OpenCharSelection")
	net.Send(ply)
end )