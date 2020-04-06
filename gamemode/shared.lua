GM.Name = "Modular Combat"
GM.Version = "0.0.1"
GM.Email = "N/A"
GM.Website = "N/A"
GM.Author = "TheCoolestPaul"

function GM:Initialize()
	self.BaseClass.Initialize( self )
	print("Loading Modular Combat v"..GM.Version)

	print("Finished loading Modular Combat v"..GM.Version)
end