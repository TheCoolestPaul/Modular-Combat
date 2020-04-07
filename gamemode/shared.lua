GM.Name = "Modular Combat"
GM.Version = "0.0.1"
GM.Email = "N/A"
GM.Website = "N/A"
GM.Author = "TheCoolestPaul"

team.SetUp(0, "Monsters", Color( 255,0,0 ), false)
team.SetUp(1, "Combie", Color( 0,0,255 ), false)
team.SetUp(2, "Resistance", Color( 0,255,0 ), false)
team.SetUp(3, "Aperature", Color( 0,100,255 ), false)

BaseWeapons = {
	"weapon_pistol",
	"weapon_357",
	"weapon_physcannon",
	"weapon_crowbar",
}

function GM:Initialize()
	self.BaseClass.Initialize( self )
	print("Finished loading Modular Combat")
end