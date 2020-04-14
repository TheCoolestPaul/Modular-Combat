util.AddNetworkString("ModComb_OpenCharSelection")
hook.Add("PlayerInitialSpawn","FullLoadSetup",function(ply) // https://wiki.facepunch.com/gmod/GM:PlayerInitialSpawn
    hook.Add("SetupMove",ply,function(self,ply,_,cmd)
        if self == ply and not cmd:IsForced() then hook.Run("PlayerFullLoad",self) hook.Remove("SetupMove",self) end
    end)
end)

hook.Add("PlayerFullLoad", "PlayerFullyLoaded", function( ply )
	print("Getting "..ply:Nick().." from the database.")
	local result = loadPlayer(ply)
	if  result != nil and result != false then
		// load char info
		print("Got "..ply:Nick().." from the database")
	elseif result == nil then
		print("SQL ERROR: "..sql.LastError())
	end
	net.Start("ModComb_OpenCharSelection")
	net.Send(ply)
end )

PlayerAverageLevel = 1
local lastCalcTime = 0
hook.Add( "Think", "Players_Calc_AverageLevel", function()
	if CurTime() < lastCalcTime then return end
	local players = player.GetAll()
	if #players == 0 then return end
	local total = 0
	for k,v in pairs(players) do
		total = total + v:GetModLevel()
	end
	PlayerAverageLevel = total/#players
	lastCalcTime = CurTime() + 30
end )