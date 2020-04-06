local plyMeta = FindMetaTable("Player")

function plyMeta:SetModCombatTeam( teamNum )
	if ( teamNum < 0 or teamNum > 4 ) then // Eliminate out of bound options
		return false
	end
	if teamNum==0 then return true end

	print("Changed "..self:Nick().."'s team to team "..team.GetName(teamNum))
	PrintMessage(HUD_PRINTTALK, self:Nick().." has joined team "..team.GetName(teamNum))
	self:SetTeam( teamNum )

	if not self:IsSuitEquipped() then
		self:EquipSuit()
	end
	for k,v in pairs(BaseWeapons) do
		self:Give(v, false)
	end

	if teamNum == 0 then// Monsters Team
		self:SetPlayerColor( Vector( 1.0,0,0 ) )
	elseif teamNum == 1 then// Blue
		self:SetPlayerColor( Vector( 0,0,1.0 ) )
	else// Green
		self:SetPlayerColor( Vector( 0,0.5,1.0 ) )
	end
	return true
end

function plyMeta:GetExp()
end

function plyMeta:AddExp( expNum )
end

function plyMeta:RemoveExp( expNum )
end
