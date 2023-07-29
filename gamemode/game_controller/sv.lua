function GM:SetInRound( b ) SetGlobalBool( "InRound", b ) end
function GM:InRound() return GetGlobalBool( "InRound", false ) end
SetGlobalBool( "InPreRound", false )
SetGlobalBool( "IsEndOfGame", false )
SetGlobalFloat( "RoundStartTime", 0.0 )

local AllMaps = file.Find( "maps/*.bsp", "GAME" )
for key, map in pairs( AllMaps ) do
	AllMaps[ key ] = string.gsub( map, ".bsp", "" )
end

function GM:GetTimeLimit()
	local limit = (GAMEMODE.GameLength * 60) + GetGlobalFloat( "RoundStartTime", 0 )
	return limit
end

function GM:CanGameStart()
	if team.NumPlayers(1) > 0 or team.NumPlayers(2) > 0 or team.NumPlayers(3) > 0 then
		return true
	else
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
	SetGlobalBool( "InPreRound", true )
	SetGlobalFloat( "RoundStartTime", CurTime() + GAMEMODE.GamePreStartTime )
	timer.Simple( GAMEMODE.GamePreStartTime, function() GAMEMODE:GameStart() end )

end

function GM:GameStart()
	print( "STARTING THE GAME" )
	UTIL_UnFreezeAllPlayers()
	SetGlobalBool( "InPreRound", false )
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
	GAMEMODE:SetInRound( false )
	UTIL_RemoveAllMonsters()
	SetGlobal2Bool( "IsEndOfGame", true )
	gamemode.Call("OnEndOfGame")
	ClearDamageTable()
	UTIL_FreezeAllPlayers()
	timer.Simple( GAMEMODE.VotingDelay, function() GAMEMODE:StartMapVote() end )
end

util.AddNetworkString( "BeginVote" )
function GM:StartMapVote()
	net.Start( "BeginVote" )
	net.Broadcast()
	timer.Simple( 0, function() GAMEMODE:FinishMapVote() end )
	SetGlobalFloat( "VoteEndTime", CurTime() + 0 )
end

function GM:GetWinningWant()

	local Votes = {}
	
	for k, ply in pairs( player.GetAll() ) do
	
		local want = ply:GetNWString( "Wants", nil )
		if ( want and not want == "" ) then
			Votes[ want ] = Votes[ want ] or 0
			Votes[ want ] = Votes[ want ] + 1			
		end
		
	end
	
	return table.GetWinningKey( Votes )
	
end

function GM:VotePlayMap( ply, map )
	
	if ( !map ) then return end
	ply:SetNWString( "Wants", map )
	
end
concommand.Add( "votemap", function( pl, cmd, args ) GAMEMODE:VotePlayMap( pl, args[1] ) end )

function GM:GetWinningMap( WinningGamemode )

	if ( GAMEMODE.WinningMap ) then return GAMEMODE.WinningMap end

	local winner = GAMEMODE:GetWinningWant()
	if ( !winner ) then return AllMaps[math.random( #AllMaps )] end
	
	return winner
	
end

util.AddNetworkString( "EndVoting" )
function GM:FinishMapVote()
	
	GAMEMODE.WinningMap = GAMEMODE:GetWinningMap()
	--GAMEMODE:ClearPlayerWants()
	
	if self.WinningMap then

		net.Start( "EndVoting" )
			net.WriteString( GAMEMODE:GetWinningMap() )
		net.Broadcast()

		-- Send bink bink notification
		timer.Simple( 3, function() GAMEMODE:ChangeGamemode() end )
	else
		-- Notifies the server owner of the issue
		ErrorNoHalt("No maps for this gamemode, forcing map to gm_construct\nPlease change this as soon as you can!\n")

		--Picks gm_construct to prevent the server from halting
		GAMEMODE.WinningMap = "gm_construct"
		timer.Simple( 3, function() 
			RunConsoleCommand( "gamemode", GAMEMODE.WorkOutWinningGamemode())
			RunConsoleCommand( "changelevel", GAMEMODE.WinningMap )
		end)
	end
end

function GM:ChangeGamemode()
	local mp = GAMEMODE:GetWinningMap()
	RunConsoleCommand( "changelevel", mp )
end

function GM:Think()
	if not GAMEMODE:InRound() then return end
	if( !GAMEMODE.IsEndOfGame and CurTime() >= GAMEMODE.GetTimeLimit() ) then
		GAMEMODE:EndOfGame()
	end
end