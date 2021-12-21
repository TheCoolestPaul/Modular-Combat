local visible = false
AdminMainFrame = nil
hook.Add( "PlayerBindPress", "PlayerShowHelpBind", function( ply, bind, pressed )
	if ( ( ply:IsAdmin() or ply:IsSuperAdmin() ) and string.find( bind, "gm_showhelp" ) ) then
		if visible and IsValid(AdminMainFrame) then
			AdminMainFrame:Close()
			visible = false
		else
			createMenu()
		end
	end
end )

function createMenu()
	visible = true
	AdminMainFrame = vgui.Create( "DFrame" )
	AdminMainFrame:SetDeleteOnClose(true)
	AdminMainFrame:SetTitle( "Modular Combat Admin" )
	AdminMainFrame:SetSize( ScrW(),ScrH() )
	AdminMainFrame:Center()
	AdminMainFrame:MakePopup()
	AdminMainFrame.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
	end

	local playerCombo = vgui.Create( "DComboBox", AdminMainFrame )
	playerCombo:SetSize( 200, 20 )
	playerCombo:SetPos( 500,300 )
	function playerCombo:OnSelect( index, text, data )
		local teamCombo = vgui.Create( "DComboBox", AdminMainFrame )
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

	local spawnMonster = vgui.Create( "DButton", AdminMainFrame )
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
	local spawnPlayer = vgui.Create( "DButton", AdminMainFrame )
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
	local spawnWeapon = vgui.Create( "DButton", AdminMainFrame )
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
	local spawnAmmo = vgui.Create( "DButton", AdminMainFrame )
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
	local spawnDrops = vgui.Create( "DButton", AdminMainFrame )
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

	local saveSpawns = vgui.Create( "DButton", AdminMainFrame )
	saveSpawns:SetSize( 200, 50 )
	saveSpawns:SetPos( 500, 700 )
	saveSpawns:SetText("SAVE Spawns")
	function saveSpawns:DoClick()
		net.Start("ModComb_SaveSpawns")
		net.SendToServer()
	end
	local clearSpawns = vgui.Create( "DButton", AdminMainFrame )
	clearSpawns:SetSize( 200, 50 )
	clearSpawns:SetPos( 500, 800 )
	clearSpawns:SetText("CLEAR Spawns")
	function clearSpawns:DoClick()
		local confirmFrame = vgui.Create( "DFrame", AdminMainFrame )
		confirmFrame:SetTitle( "Confirm Clear Spawns" )
		confirmFrame:SetSize( ScrW(),ScrH() )
		confirmFrame:Center()
		confirmFrame:MakePopup()
		confirmFrame.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
		end
		local confirmButton = vgui.Create( "DButton", confirmFrame )
		confirmButton:SetSize( 200, 50 )
		confirmButton:SetPos( ScrW()/2-200, ScrH()/2 )
		confirmButton:SetText("CONFIRM")
		function confirmButton:DoClick()
			net.Start("ModComb_ClearSpawns")
			net.SendToServer()
		end
		local closeButton = vgui.Create( "DButton", confirmFrame )
		closeButton:SetSize( 200, 50 )
		closeButton:SetPos( ScrW()/2+200, ScrH()/2 )
		closeButton:SetText("CANCEL")
		function closeButton:DoClick()
			confirmFrame:Close()
		end
	end

	local godMode = vgui.Create( "DButton", AdminMainFrame )
	godMode:SetSize( 200, 50 )
	godMode:SetPos( 900, 500 )
	godMode:SetText( "Toggle Godmode" )
	function godMode:DoClick()
		net.Start( "ModCombAdminGod" )
		net.SendToServer()
	end
	local playerESP = vgui.Create( "DButton", AdminMainFrame )
	playerESP:SetSize( 200, 50 )
	playerESP:SetPos( 900, 550 )
	playerESP:SetText( "Toggle Player ESP" )
	function playerESP:DoClick()
		net.Start( "ModCombAdminPlayerESP" )
		net.SendToServer()
	end
	local spawnsESP = vgui.Create( "DButton", AdminMainFrame )
	spawnsESP:SetSize( 200, 50 )
	spawnsESP:SetPos( 900, 600 )
	spawnsESP:SetText( "Toggle Spawn ESP" )
	function spawnsESP:DoClick()
		net.Start( "ModCombAdminSpawnersESP" )
		net.SendToServer()
	end

	local spawnTool = vgui.Create( "DButton", AdminMainFrame )
	spawnTool:SetSize( 200, 50 )
	spawnTool:SetPos( 900, 650 )
	spawnTool:SetText( "Give Spawn Tool Editor" )
	function spawnTool:DoClick()
		net.Start( "ModCombGiveSpawnTool" )
		net.SendToServer()
	end
end
