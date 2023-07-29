PlayerAverageLevel = 1
local lastCalcTime = 0
hook.Add( "Think", "Players_Calc_AverageLevel", function()
	if CurTime() < lastCalcTime then return end
	local players = player.GetAll()
	if #players == 0 then return end
	local total = 0
	for k,v in pairs(players) do
		if v:GetActiveCharNum() != nil then
			total = total + playerData[v:SteamID()][v:GetActiveCharNum()].Level
		end
	end
	PlayerAverageLevel = total/#players
	lastCalcTime = CurTime() + 30
end )

local lastSQLSave = 0
hook.Add( "Think", "AutoSavePlayers", function()
	if CurTime() <= lastSQLSave or #player.GetHumans() == 0 then return end
	print("Sending player data to SQL")
	for _,ply in pairs( player.GetHumans() ) do
		if IsValid( ply ) and ply:GetActiveCharNum() != 0 then -- Only if they're valid and in-game
			ModularCombatDB:savePlayerData( ply )
		end
	end
	lastSQLSave = CurTime() + ( 5 * 60 ) -- 5 minutes
end )