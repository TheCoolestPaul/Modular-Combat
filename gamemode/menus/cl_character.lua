playerData = {}
net.Receive( "ModComb_SyncData", function( len, ply )
	for i = 1, 3 do
		if net.ReadBool() then
			playerData[i] = util.JSONToTable( net.ReadString() )
		end
	end
end )

function openCharSelection()
	local MainFrame = vgui.Create( "DFrame" )
	MainFrame:SetTitle( "" )
	MainFrame:SetSize( ScrW(),ScrH() )
	MainFrame:SetDraggable( false )
	MainFrame:Center()
	MainFrame:MakePopup()
	MainFrame.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
	end

	local char1Frame = vgui.Create( "DFrame", MainFrame )
	char1Frame:SetTitle( "" )
	char1Frame:SetSize( ScrW()/3,ScrH() )
	char1Frame:Dock(LEFT)
	char1Frame:SetDraggable( false )
	char1Frame:MakePopup()
	char1Frame:ShowCloseButton( false )
	char1Frame.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 150 ) )
	end
	local char2Frame = vgui.Create( "DFrame", MainFrame )
	char2Frame:SetTitle( "" )
	char2Frame:SetSize( ScrW()/3,ScrH() )
	char2Frame:Dock(FILL)
	char2Frame:SetDraggable( false )
	char2Frame:MakePopup()
	char2Frame:ShowCloseButton( false )
	char2Frame.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
	end
	local char3Frame = vgui.Create( "DFrame", MainFrame )
	char3Frame:SetTitle( "" )
	char3Frame:SetSize( ScrW()/3,ScrH() )
	char3Frame:Dock(RIGHT)
	char3Frame:SetDraggable( false )
	char3Frame:MakePopup()
	char3Frame:ShowCloseButton( false )
	char3Frame.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 150 ) )
	end


	local char1Model = vgui.Create( "DModelPanel", char1Frame )
	char1Model:SetSize( 0, 400 )
	char1Model:Dock( TOP )
	char1Model:SetLookAt( Vector( 0, 0, 0 ) )
	if playerData[1] != nil then
		char1Model:SetModel( playerData[1].Model )
	end
	if char1Model.Entity then
		function char1Model.Entity:GetPlayerColor() return team.GetColor(playerData[1].Team):ToVector() end
	end
	function char1Model:LayoutEntity( ent )
		if ent then
			ent:SetPos(Vector(40,30,-30))
			ent:SetAngles(Angle(-15,35,0))
		end
	end
	local char2Model = vgui.Create( "DModelPanel", char2Frame )
	char2Model:SetSize( 0, 400 )
	char2Model:Dock( TOP )
	char2Model:SetLookAt( Vector( 0, 0, 0 ) )
	if playerData[2] != nil then
		char2Model:SetModel( playerData[2].Model )
	end
	if char2Model.Entity then
		function char2Model.Entity:GetPlayerColor() return team.GetColor(playerData[2].Team):ToVector() end
	end
	function char2Model:LayoutEntity( ent )
		if ent then
			ent:SetPos(Vector(40,30,-30))
			ent:SetAngles(Angle(-15,35,0))
		end
	end
	local char3Model = vgui.Create( "DModelPanel", char3Frame )
	char3Model:SetSize( 0, 400 )
	char3Model:Dock( TOP )
	char3Model:SetLookAt( Vector( 0, 0, 0 ) )
	if playerData[3] != nil then
		char3Model:SetModel( playerData[3].Model )
	end
	if char3Model.Entity then
		function char3Model.Entity:GetPlayerColor() return team.GetColor(playerData[3].Team):ToVector() end
	end
	function char3Model:LayoutEntity( ent )
		if ent then
			ent:SetPos(Vector(40,30,-30))
			ent:SetAngles(Angle(-15,35,0))
		end
	end


	local char1NameLabel = vgui.Create( "DLabel", char1Frame )
	char1NameLabel:Dock( FILL )
	char1NameLabel:SetFont( "DermaLarge" )
	char1NameLabel:SetSize( 0, 50 )
	if playerData[1] == nil then
		char1NameLabel:SetText( "Name: N/A \n\nTeam: N/A \n\nLevel: N/A" )
	else
		char1NameLabel:SetText( "Name: "..playerData[1].Name.." \n\nTeam: "..team.GetName(playerData[1].Team).." \n\nLevel: "..playerData[1].Level )
	end
	local char2NameLabel = vgui.Create( "DLabel", char2Frame )
	char2NameLabel:Dock( FILL )
	char2NameLabel:SetFont( "DermaLarge" )
	char2NameLabel:SetSize( 0, 50 )
	if playerData[2] == nil then
		char2NameLabel:SetText( "Name: N/A \n\nTeam: N/A \n\nLevel: N/A" )
	else
		char2NameLabel:SetText( "Name: "..playerData[2].Name.." \n\nTeam: "..team.GetName(playerData[2].Team).." \n\nLevel: "..playerData[2].Level )
	end
	local char3NameLabel = vgui.Create( "DLabel", char3Frame )
	char3NameLabel:Dock( FILL )
	char3NameLabel:SetFont( "DermaLarge" )
	char3NameLabel:SetSize( 0, 50 )
	if playerData[3] == nil then
		char3NameLabel:SetText( "Name: N/A \n\nTeam: N/A \n\nLevel: N/A" )
	else
		char3NameLabel:SetText( "Name: "..playerData[3].Name.." \n\nTeam: "..team.GetName(playerData[3].Team).." \n\nLevel: "..playerData[3].Level )
	end


	local char1 = vgui.Create( "DButton", char1Frame )
	char1:SetSize( 0, 400 )
	char1:Dock( BOTTOM )
	char1:SetText( "" )
	function char1:Paint( w, h )
		draw.RoundedBox( 20, 0, 0, w, h, Color( 0,0,0,255 ) )
		local text = "Create a Character"
		if playerData[1] != nil then text = "Play" end
		draw.SimpleTextOutlined( text, "DermaLarge", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
	end
	function char1:DoClick()
		MainFrame:Close()
		if playerData[1] == nil then
			playAs( true, 1 )
		else
			playAs( false, 1 )
		end
	end
	local char2 = vgui.Create( "DButton", char2Frame )
	char2:SetSize( 0, 400 )
	char2:Dock( BOTTOM )
	char2:SetText( "" )
	function char2:Paint( w, h )
		draw.RoundedBox( 20, 0, 0, w, h, Color( 0,0,0,255 ) )
		local text = "Create a Character"
		if playerData[2] != nil then text = "Play" end
		draw.SimpleTextOutlined( text, "DermaLarge", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
	end
	function char2:DoClick()
		MainFrame:Close()
		if playerData[2] == nil then
			playAs( true, 2 )
		else
			playAs( false, 2 )
		end
	end
	local char3 = vgui.Create( "DButton", char3Frame )
	char3:SetSize( 0, 400 )
	char3:Dock( BOTTOM )
	char3:SetText( "" )
	function char3:Paint( w, h )
		draw.RoundedBox( 20, 0, 0, w, h, Color( 0,0,0,255 ) )
		local text = "Create a Character"
		if playerData[3] != nil then text = "Play" end
		draw.SimpleTextOutlined( text, "DermaLarge", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
	end
	function char3:DoClick()
		MainFrame:Close()
		if playerData[3] == nil then
			playAs( true, 3 )
		else
			playAs( false, 3 )
		end
	end
end

local teamModels = {
	[1] = {
		"models/player/combine_soldier.mdl",
		"models/player/combine_super_soldier.mdl",
		"models/player/combine_soldier_prisonguard.mdl",
		"models/player/police.mdl",
		"models/player/police_fem.mdl",
	},
	[2] = {
		"models/player/Group03/male_01.mdl",
		"models/player/Group03/male_02.mdl",
		"models/player/Group03/male_03.mdl",
		"models/player/Group03/male_04.mdl",
		"models/player/Group03/male_05.mdl",
		"models/player/Group03/male_06.mdl",
		"models/player/Group03/male_07.mdl",
		"models/player/Group03/male_08.mdl",
		"models/player/Group03/male_09.mdl",
		"models/player/Group03/female_01.mdl",
		"models/player/Group03/female_02.mdl",
		"models/player/Group03/female_03.mdl",
		"models/player/Group03/female_04.mdl",
		"models/player/Group03/female_05.mdl",
		"models/player/Group03/female_06.mdl",
	},
	[3] = {
		"models/player/hostage/hostage_01.mdl",
		"models/player/hostage/hostage_02.mdl",
		"models/player/hostage/hostage_03.mdl",
		"models/player/hostage/hostage_04.mdl",
		"models/player/p2_chell.mdl",
		"models/player/kleiner.mdl",
		"models/player/magnusson.mdl",
	},
}

function playAs(creation, charNum)
	if not creation then
		local teamNum = 1
		if charNum == 1 then
			teamNum = playerData[1].Team
		elseif charNum == 2 then
			teamNum = playerData[2].Team
		else
			teamNum = playerData[3].Team
		end
		net.Start( "PickedChar" )
		net.WriteInt( teamNum, 11 )
		net.WriteInt( charNum, 3 )
		net.SendToServer()
	else
		local CreationFrame = vgui.Create( "DFrame" )
		CreationFrame:SetTitle( "" )
		CreationFrame:SetSize( ScrW(),ScrH() )
		CreationFrame:SetDraggable( false )
		CreationFrame:Center()
		CreationFrame:MakePopup()
		CreationFrame.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
		end

		local activeTab = 1 -- combine
		local activeModel = 1 -- first model

		local ModelSelectorFrame = vgui.Create( "DFrame", CreationFrame )
		ModelSelectorFrame:SetTitle( "" )
		ModelSelectorFrame:SetSize( CreationFrame:GetWide()/2, CreationFrame:GetTall() )
		ModelSelectorFrame:Dock(RIGHT)
		ModelSelectorFrame:SetDraggable( false )
		ModelSelectorFrame:ShowCloseButton( false )
		ModelSelectorFrame.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
		end
		local ButtonFrame = vgui.Create( "DFrame", ModelSelectorFrame )
		ButtonFrame:SetTitle( "" )
		ButtonFrame:SetSize( 0, ScrH()/8 )
		ButtonFrame:Dock(BOTTOM)
		ButtonFrame:SetDraggable( false )
		ButtonFrame:ShowCloseButton( false )
		ButtonFrame.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
		end

		local model = vgui.Create( "DModelPanel", ModelSelectorFrame )
		model:Dock(FILL)
		model:SetModel(teamModels[activeTab][activeModel])

		local leftChoice = vgui.Create( "DButton", ButtonFrame )
		leftChoice:SetText( "<" )
		leftChoice:Dock(LEFT)
		function leftChoice:DoClick()
			if activeModel == 1 then
				activeModel = table.Count(teamModels[activeTab])
			else
				activeModel = activeModel - 1
			end
			model:SetModel(teamModels[activeTab][activeModel])
		end
		local rightChoice = vgui.Create( "DButton", ButtonFrame )
		rightChoice:SetText( ">" )
		rightChoice:Dock(RIGHT)
		function rightChoice:DoClick()
			if activeModel == table.Count(teamModels[activeTab]) then
				activeModel = 1
			else
				activeModel = activeModel + 1
			end
			model:SetModel(teamModels[activeTab][activeModel])
		end

		local TeamSelectorFrame = vgui.Create( "DFrame", CreationFrame )
		TeamSelectorFrame:SetTitle( "" )
		TeamSelectorFrame:SetSize( CreationFrame:GetWide()/2, CreationFrame:GetTall() )
		TeamSelectorFrame:Dock(LEFT)
		TeamSelectorFrame:SetDraggable( false )
		TeamSelectorFrame:ShowCloseButton( false )
		TeamSelectorFrame.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
		end

		local nameLabel = vgui.Create( "DLabel", TeamSelectorFrame )
		nameLabel:SetSize(0, 50)
		nameLabel:Dock(TOP)
		nameLabel:SetFont("DermaLarge")
		nameLabel:SetText( "Character Name" )

		local nameEntry = vgui.Create( "DTextEntry", TeamSelectorFrame )
		nameEntry:SetSize( 0, 50 )
		nameEntry:Dock(TOP)
		nameEntry:SetValue( "John Johnson" )
		nameEntry.OnEnter = function( self )
		end

		local charTeamLabel = vgui.Create( "DLabel", TeamSelectorFrame )
		charTeamLabel:SetSize(TeamSelectorFrame:GetWide(), 50)
		charTeamLabel:SetPos( 0, TeamSelectorFrame:GetTall()/2-200 )
		charTeamLabel:SetFont("DermaLarge")
		charTeamLabel:SetText( "Character Team" )

		local combineButton = vgui.Create( "DButton", TeamSelectorFrame )
		combineButton:SetText( "Combine" )
		combineButton:SetPos( 0, TeamSelectorFrame:GetTall()/2-100 )
		combineButton:SetSize( TeamSelectorFrame:GetWide(), 100 )
		function combineButton:DoClick()
			activeTab = 1
			activeModel = 1
			model:SetModel(teamModels[activeTab][activeModel])
		end
		local resistanceButton = vgui.Create( "DButton", TeamSelectorFrame )
		resistanceButton:SetText( "Resistance" )
		resistanceButton:SetPos( 0, TeamSelectorFrame:GetTall()/2+10 )
		resistanceButton:SetSize( TeamSelectorFrame:GetWide(), 100 )
		function resistanceButton:DoClick()
			activeTab = 2
			activeModel = 1
			model:SetModel(teamModels[activeTab][activeModel])
		end
		local aperatureButton = vgui.Create( "DButton", TeamSelectorFrame )
		aperatureButton:SetText( "Aperature" )
		aperatureButton:SetPos( 0, TeamSelectorFrame:GetTall()/2+120 )
		aperatureButton:SetSize( TeamSelectorFrame:GetWide(), 100 )
		function aperatureButton:DoClick()
			activeTab = 3
			activeModel = 1
			model:SetModel(teamModels[activeTab][activeModel])
		end


		local confirmButton = vgui.Create( "DButton", ButtonFrame )
		confirmButton:SetText( "SELECT" )
		confirmButton:Dock(FILL)
		function confirmButton:DoClick()
			CreationFrame:Close()
			net.Start("FinsihedCharCreation")
			net.WriteInt(activeTab, 3)
			net.WriteString(teamModels[activeTab][activeModel])
			net.WriteString(nameEntry:GetValue())
			net.WriteInt(charNum, 3)
			net.SendToServer()
		end

	end
end

net.Receive("ModComb_OpenCharSelection", openCharSelection)