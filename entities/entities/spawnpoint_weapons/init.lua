AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:DrawShadow( false )
end

function ENT:Think()
	if CurTime() < self:GetLastSpawn() or not GAMEMODE:InRound() then return end
	local wepClass = PickupWeapons[math.random(#PickupWeapons)]
	if IsValid( self:GetLastEntity() ) then
		if wepClass == self:GetLastEntity():GetClass() then
			wepClass = PickupWeapons[math.random(#PickupWeapons)]
		end
		if not IsValid( self:GetLastEntity():GetParent() ) then
			self:GetLastEntity():Remove()
		end
	end
	self:SetLastEntity( ents.Create(wepClass) )
	self:GetLastEntity():SetPos( Vector( self:GetPos().x, self:GetPos().y, self:GetPos().z + 5 ) )
	self:GetLastEntity():Spawn()
	self:SetLastSpawn( CurTime() + 30 )
end