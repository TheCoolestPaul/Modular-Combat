GM.Name = "Modular Combat"
GM.Version = "0.0.1"
GM.Email = "N/A"
GM.Website = "N/A"
GM.Author = "TheCoolestPaul"

team.SetUp( 0, "Monsters", Color( 255,0,0 ), false )
team.SetUp( 1, "Combie", Color( 0,0,255 ), false )
team.SetUp( 2, "Resistance", Color( 0,255,0 ), false )
team.SetUp( 3, "Aperature", Color( 0,100,255 ), false )

SpawnableMonsters = {
	[1] = "npc_zombie",
	[2] = "npc_manhack",
	[3] = "npc_poisonzombie",
	[4] = "npc_headcrab",
	[5] = "npc_fastzombie",
	[6] = "npc_fastzombie_torso",
	[7] = "npc_zombie_torso",
	[8] = "npc_antlion",
	[9] = "npc_vortigaunt",
	[10] = "npc_antlionguard",
}
MonsterXP = {
	{ "npc_antlion",  6 },
	{ "npc_antlionguard", 15 },
	{ "npc_headcrab_fast", 3 },
	{ "npc_fastzombie", 5 },
	{ "npc_fastzombie_torso", 5 },
	{ "npc_headcrab", 2 },
	{ "npc_headcrab_black", 3 },
	{ "npc_headcrab_poison", 3},
	{ "npc_poisonzombie", 6 },
	{ "npc_zombie", 5 },
	{ "npc_zombie_torso", 4 },
	{ "npc_manhack", 2 },
	{ "npc_vortigaunt", 5 },
	{ "npc_rollermine", 2 },
}
function GetMonsterBaseEXP( class )
	for k,v in pairs(MonsterXP) do
		if v[1] == class then
			return v[2]
		end
	end
	return false
end

function IsSpawner( ent )
	if ent:GetClass() == "spawnpoint_ammo" or ent:GetClass() == "spawnpoint_drops" or ent:GetClass() == "spawnpoint_monsters" or ent:GetClass() == "spawnpoint_players" or ent:GetClass() == "spawnpoint_weapons" then
		return true
	end
	return false
end

local function AdminOnlyNoClip( ply )
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		return true
	end
	return false
end
hook.Add( "PlayerNoClip", "AdminOnlyNoClip", AdminOnlyNoClip )

BaseWeapons = {
	"weapon_pistol",
	"weapon_357",
	"weapon_physcannon",
	"weapon_crowbar",
}
PickupWeapons = {
	"weapon_crossbow",
	"weapon_frag",
	"weapon_ar2",
	"weapon_rpg",
	"weapon_slam",
	"weapon_shotgun",
	"weapon_smg1",
}
PickupDrops = {
	"item_battery",
	"item_healthvial",
	"item_healthkit",
}
PickupAmmo = {
	{ "item_ammo_357", "357" },
	{ "item_ammo_357_large", "357" },
	{ "item_ammo_ar2", "AR2" },
	{ "item_ammo_ar2_large", "AR2" },
	{ "item_ammo_ar2_altfire", "AR2AltFire" },
	{ "item_ammo_crossbow", "XBowBolt" },
	{ "item_ammo_pistol", "Pistol" },
	{ "item_ammo_pistol_large", "Pistol" },
	{ "item_rpg_round", "RPG_Round" },
	{ "item_ammo_smg1", "SMG1" },
	{ "item_ammo_smg1_large", "SMG1" },
	{ "item_ammo_smg1_grenade", "SMG1_Grenade" },
	{ "item_box_buckshot", "Buckshot" },
}
function GM:Initialize()
	self.BaseClass.Initialize( self )
	print("Finished loading Modular Combat")
end