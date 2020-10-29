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
	local ammoClass = PickupAmmo[math.random(#PickupAmmo)][1]
	if IsValid( self:GetLastEntity() ) then
		if ammoClass == self:GetLastEntity():GetClass() then
			ammoClass = PickupAmmo[math.random(#PickupAmmo)][1]
		end
		self:GetLastEntity():Remove()
	end
	self:SetLastEntity( ents.Create(ammoClass) )
	self:GetLastEntity():SetPos( Vector( self:GetPos().x, self:GetPos().y, self:GetPos().z + 5 ) )
	self:GetLastEntity():Spawn()
	self:SetLastSpawn( CurTime() + 20 )
end