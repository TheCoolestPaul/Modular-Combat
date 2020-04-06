GM.Name = "Modular Combat"
GM.Version = "0.0.1"
GM.Email = "N/A"
GM.Website = "N/A"
GM.Author = "TheCoolestPaul"

team.SetUp(0, "Monsters", Color( 255,0,0 ), false)
team.SetUp(1, "Blue", Color( 0,0,255 ), true)
team.SetUp(2, "Green", Color( 0,255,0 ), true)

function GM:Initialize()
	self.BaseClass.Initialize( self )
	print("Loading Modular Combat")
	print("Finished loading Modular Combat")
end