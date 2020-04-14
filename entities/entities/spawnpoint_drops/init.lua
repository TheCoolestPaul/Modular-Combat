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
	if CurTime() < self:GetLastSpawn() then return end
	local dropClass = PickupDrops[math.random(#PickupDrops)]
	if IsValid( self:GetLastEntity() ) then
		if dropClass == self:GetLastEntity():GetClass() then
			dropClass = PickupDrops[math.random(#PickupDrops)]
		end
		self:GetLastEntity():Remove()
	end
	self:SetLastEntity( ents.Create(dropClass) )
	self:GetLastEntity():SetPos( Vector( self:GetPos().x, self:GetPos().y, self:GetPos().z + 5 ) )
	self:GetLastEntity():Spawn()
	self:SetLastSpawn( CurTime() + 20 )
end