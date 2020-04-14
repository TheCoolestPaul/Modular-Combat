ENT.Type = "anim"
ENT.PrintName = "Spawnpoint - Weapons"
ENT.Author = "TheCoolestPaul"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar( "Float", 0, "LastSpawn" )
	self:NetworkVar( "Entity", 1, "LastEntity" )
	if SERVER then
		self:SetLastSpawn( 0 )
		self:SetLastEntity( nil )
	end
end