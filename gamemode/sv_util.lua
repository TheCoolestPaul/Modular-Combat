function UTIL_FreezeAllPlayers()

	for k,v in pairs( player.GetAll() ) do
		if ( v:Team() != TEAM_SPECTATOR and v:Team() != TEAM_CONNECTING ) then
			v:Lock()
		end
	end

end

function UTIL_UnFreezeAllPlayers()

	for k,v in pairs( player.GetAll() ) do
		if ( v:Team() != TEAM_SPECTATOR and v:Team() != TEAM_CONNECTING ) then
			v:UnLock()
		end
	end

end

function UTIL_RemoveAllMonsters()
	for k,v in pairs( ents.GetAll() ) do
		if string.StartWith( string.lower( v:GetClass() ), "npc_" ) then
			v:Remove()
		end
	end
end
