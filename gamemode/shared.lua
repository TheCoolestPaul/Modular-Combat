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


if CLIENT then
	local MainFrame = vgui.Create( "DFrame" )
	MainFrame:SetTitle( "Modular Combat Admin" )
	MainFrame:SetSize( ScrW(),ScrH() )
	MainFrame:Center()
	MainFrame:MakePopup()
	MainFrame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) ) -- Draw a red box instead of the frame
	end


	local playerCombo = vgui.Create( "DComboBox", MainFrame )
	playerCombo:SetSize( 200, 20 )
	playerCombo:SetPos( 500,300 )
	function playerCombo:OnSelect( index, text, data )
		local teamCombo = vgui.Create( "DComboBox", MainFrame )
		teamCombo:SetSize( 100, 20 )
		teamCombo:SetPos( 700,300 )
		function teamCombo:OnSelect( index2, text2, data2 )
			net.Start("ModCombAdminTeamSet")
			net.WriteInt(data, 11)
			net.WriteInt(data2, 11)
			net.SendToServer()
		end
		for k,v in pairs(team.GetAllTeams()) do
			teamCombo:AddChoice(v.Name, k)
		end
	end
	for k,v in pairs(player.GetAll()) do
		playerCombo:AddChoice(v:Nick(), v:EntIndex())
	end

end
