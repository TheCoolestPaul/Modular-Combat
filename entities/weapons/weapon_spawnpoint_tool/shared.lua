if( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

if( CLIENT ) then
	SWEP.PrintName = "Spawnpoint Editor"
	SWEP.Slot = 0
	SWEP.SlotPos = 0
end

SWEP.Base = "weapon_base"
SWEP.HoldType = "pistol"

SWEP.Contact = "N/A"
SWEP.Purpose = "Use this to create spawnpoints."
SWEP.Instructions = "LClick - Create Point | RClick - Remove Point | Reload - Change Point Type"

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel	= "models/weapons/w_pistol.mdl"

SWEP.UseHands = true
SWEP.ViewModelFOV = 54

SWEP.SpawnTypes = {
	"players",
	"ammo",
	"weapons",
	"drops",
	"monsters",
}

SWEP.CurrentSpawnType = 1

SWEP.Primary.Sound = Sound( "Weapon_StunStick.Melee_HitWorld" )
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.Sound = Sound( "Weapon_StunStick.Melee_Hit" )
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

function SWEP:PrimaryAttack()
	self:EmitSound( self.Primary.Sound )
	if ( CLIENT ) then return end
	AddSpawn( self.SpawnTypes[self.CurrentSpawnType], self.Owner:GetEyeTrace().HitPos, self.Owner:GetAngles() )
end
 
function SWEP:SecondaryAttack()
	self:EmitSound( self.Primary.Sound )
	if ( CLIENT ) then return end
	for _,ent in pairs( ents.FindInSphere( self.Owner:GetEyeTrace().HitPos, 10.0 ) ) do
		if IsSpawner( ent ) then
			RemoveSpawn( ent )
		end
	end
end

SWEP.LastReload = 0
function SWEP:Reload()
	if CurTime() < self.LastReload then return end
	if self.CurrentSpawnType == #self.SpawnTypes then
		self.CurrentSpawnType = 1
	else
		self.CurrentSpawnType = self.CurrentSpawnType + 1
	end
	self.LastReload = CurTime() + 0.2
end

function SWEP:DrawHUD()
	draw.SimpleTextOutlined( "Type: "..self.SpawnTypes[self.CurrentSpawnType], "DermaLarge", ScrW()/2, ScrH()-100, Color( 255,255,255,255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255) )
	for _,ent in ipairs ( ents.GetAll() ) do
		if IsSpawner( ent ) then
			local pos = ent:GetPos() + Vector(0,0,10)
			pos = pos:ToScreen()
			draw.DrawText( ent:GetClass(), "DermaDefault", pos.x, pos.y - 10, color, 1 )
		end
	end
end