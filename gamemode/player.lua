local ply = FindMetaTable("Player")

function ply:SetGamemodeTeam( n )
	if n < 0 or n > 2 then return end
end