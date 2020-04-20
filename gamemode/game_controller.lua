function GM:SetInRound( b ) SetGlobalBool( "InRound", b ) end
function GM:InRound() return GetGlobalBool( "InRound", false ) end
SetGlobalBool( "IsEndOfGame", false )
SetGlobalFloat( "RoundStartTime", 0.0 )

function GM:GetTimeLimit()
	local limit = (GAMEMODE.GameLength * 60) + GetGlobalFloat( "RoundStartTime", 0 )
	print("LIMIT: "..limit.."   CURTIME: "..CurTime())
	return limit
end

function GM:CanGameStart()
	if team.NumPlayers(1) > 0 or team.NumPlayers(2) > 0 or team.NumPlayers(3) > 0 then
		print("we can start")
		return true
	else
		print("we cant start")
		return false
	end
end

function GM:PreGameStart()

	if GAMEMODE:InRound() then
		return
	end
	if( CurTime() >= GAMEMODE.GetTimeLimit() ) then
		GAMEMODE:EndOfGame()
		return
	end
	if not GAMEMODE:CanGameStart()  then
		timer.Simple( 5, function() GAMEMODE:PreGameStart() end ) -- In a second, check to see if we can start
		return
	end
	timer.Simple( GAMEMODE.GamePreStartTime, function() GAMEMODE:GameStart() end )
	SetGlobalFloat( "RoundStartTime", CurTime() + GAMEMODE.GamePreStartTime )

end

function GM:GameStart()
	print("STARTING THE GAME")
	UTIL_UnFreezeAllPlayers()
	GAMEMODE:SetInRound( true )
end

function GM:OnEndOfGame()
	print("Ending the game")
	ReadSound( "victory.mp3" )
	for k,v in pairs( player.GetAll() ) do
		v:Lock()
		v:ConCommand( "+showscores" )
	end
end

function GM:EndOfGame()
	if GetGlobalBool("IsEndOfGame", false) then return end
	print("GAME NEEDS TO END")
	GAMEMODE:SetInRound( false )
	UTIL_RemoveAllMonsters()
	SetGlobalBool( "IsEndOfGame", true )
	gamemode.Call("OnEndOfGame")
	UTIL_FreezeAllPlayers()
	PrintMessage( HUD_PRINTTALK, "Starting gamemode voting..." )
	timer.Simple( GAMEMODE.VotingDelay, function() GAMEMODE:StartGamemodeVote() end )
end

function GM:Think()
	if not GM:InRound() then return end
	if( !GAMEMODE.IsEndOfGame and CurTime() >= GAMEMODE.GetTimeLimit() ) then
		GAMEMODE:EndOfGame()
	end
end