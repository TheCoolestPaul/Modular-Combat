hook.Add( "PlayerBindPress", "PlayerBindPressExample", function( ply, bind, pressed )
	if ( ( ply:IsAdmin() or ply:IsSuperAdmin() ) and string.find( bind, "gm_showhelp" ) ) then
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
				net.WriteInt(data2, 11)
				net.WriteInt(data, 11)
				net.SendToServer()
			end
			for k,v in pairs(team.GetAllTeams()) do
				teamCombo:AddChoice(v.Name, k)
			end
		end
		for k,v in pairs(player.GetAll()) do
			playerCombo:AddChoice(v:Nick(), v:EntIndex())
		end

		local spawnMonster = vgui.Create( "DButton", MainFrame )
		spawnMonster:SetSize( 200, 50 )
		spawnMonster:SetPos( 500, 400 )
		spawnMonster:SetText("Create A Monster Spawn")
		function spawnMonster:DoClick()
			net.Start("ModComb_AddSpawner")
			net.WriteString("monsters")
			net.WriteVector(LocalPlayer():GetPos())
			net.WriteAngle(LocalPlayer():GetAngles())
			net.SendToServer()
		end
		local spawnPlayer = vgui.Create( "DButton", MainFrame )
		spawnPlayer:SetSize( 200, 50 )
		spawnPlayer:SetPos( 500, 450 )
		spawnPlayer:SetText("Create A Player Spawn")
		function spawnPlayer:DoClick()
			net.Start("ModComb_AddSpawner")
			net.WriteString("players")
			net.WriteVector(LocalPlayer():GetPos())
			net.WriteAngle(LocalPlayer():GetAngles())
			net.SendToServer()
		end
		local spawnWeapon = vgui.Create( "DButton", MainFrame )
		spawnWeapon:SetSize( 200, 50 )
		spawnWeapon:SetPos( 500, 500 )
		spawnWeapon:SetText("Create a Weapon Spawn")
		function spawnWeapon:DoClick()
			net.Start("ModComb_AddSpawner")
			net.WriteString("weapons")
			net.WriteVector(LocalPlayer():GetPos())
			net.WriteAngle(LocalPlayer():GetAngles())
			net.SendToServer()
		end
		local spawnAmmo = vgui.Create( "DButton", MainFrame )
		spawnAmmo:SetSize( 200, 50 )
		spawnAmmo:SetPos( 500, 550 )
		spawnAmmo:SetText("Create an Ammo Spawn")
		function spawnAmmo:DoClick()
			net.Start("ModComb_AddSpawner")
			net.WriteString("ammo")
			net.WriteVector(LocalPlayer():GetPos())
			net.WriteAngle(LocalPlayer():GetAngles())
			net.SendToServer()
		end
		local spawnDrops = vgui.Create( "DButton", MainFrame )
		spawnDrops:SetSize( 200, 50 )
		spawnDrops:SetPos( 500, 600 )
		spawnDrops:SetText("Create a Drop Spawn")
		function spawnDrops:DoClick()
			net.Start("ModComb_AddSpawner")
			net.WriteString("drops")
			net.WriteVector(LocalPlayer():GetPos())
			net.WriteAngle(LocalPlayer():GetAngles())
			net.SendToServer()
		end

		local saveSpawns = vgui.Create( "DButton", MainFrame )
		saveSpawns:SetSize( 200, 50 )
		saveSpawns:SetPos( 500, 700 )
		saveSpawns:SetText("Save Spawns")
		function saveSpawns:DoClick()
			net.Start("ModComb_SaveSpawns")
			net.SendToServer()
		end
	end
end )