local PANEL = {}
local AllMaps = {}

function PANEL:Init()

	self:SetSkin( GAMEMODE.HudSkin )
	self:ParentToHUD()
	
	self.ControlCanvas = vgui.Create( "Panel", self )
	self.ControlCanvas:MakePopup()
	self.ControlCanvas:SetKeyboardInputEnabled( false )
	
	self.lblCountDown = vgui.Create( "DLabel", self.ControlCanvas )
	self.lblCountDown:SetText( "60" )
	
	self.lblActionName = vgui.Create( "DLabel", self.ControlCanvas )
	
	self.ctrlList = vgui.Create( "DPanelList", self.ControlCanvas )
	self.ctrlList:SetDrawBackground( false )
	self.ctrlList:SetSpacing( 2 )
	self.ctrlList:SetPadding( 2 )
	self.ctrlList:EnableHorizontal( true )
	self.ctrlList:EnableVerticalScrollbar()
	
	self.Peeps = {}
	
	for i =1, game.MaxPlayers() do
	
		self.Peeps[i] = vgui.Create( "DImage", self.ctrlList:GetCanvas() )
		self.Peeps[i]:SetSize( 16, 16 )
		self.Peeps[i]:SetZPos( 1000 )
		self.Peeps[i]:SetVisible( false )
		self.Peeps[i]:SetImage( "icon16/emoticon_smile.png" )
	
	end

end

function PANEL:PerformLayout()
	
	local cx, cy = chat.GetChatBoxPos()
	local cw, ch = chat.GetChatBoxSize()
	
	self:SetPos( 0, 0 )
	self:SetSize( ScrW(), ScrH() )
	
	self.ControlCanvas:StretchToParent( 0, 0, 0, 0 )
	self.ControlCanvas:SetWide( ( math.Round((ScrW() / 256) - 0.5) * 256 ) + 17 )
	self.ControlCanvas:SetTall( cy - 30 + (ch * 0.5) )
	self.ControlCanvas:SetPos( 0, 30 )
	self.ControlCanvas:CenterHorizontal()
	self.ControlCanvas:SetZPos( 0 )
	
	--self.lblCountDown:SetFont( "DERMALARGE" )
	self.lblCountDown:AlignRight()
	self.lblCountDown:SetTextColor( color_white )
	self.lblCountDown:SetContentAlignment( 6 )
	self.lblCountDown:SetWidth( 500 )
	
	--self.lblActionName:SetFont( "DERMALARGE" )
	self.lblActionName:AlignLeft()
	self.lblActionName:SetTextColor( color_white )
	self.lblActionName:SizeToContents()
	self.lblActionName:SetWidth( 500 )
	
	self.ctrlList:StretchToParent( 0, 60, 0, 0 )

end

function PANEL:ChooseMap()

	self.lblActionName:SetText( "Which Map?" )
	self:ResetPeeps()
	self.ctrlList:Clear()
	
	for id, mapname in RandomPairs( AllMaps ) do
		local lbl = vgui.Create( "DButton", self.ctrlList )
		lbl:SetText( mapname )
		
		Derma_Hook( lbl, 	"Paint", 				"Paint", 	"MapButton" )
		Derma_Hook( lbl, 	"ApplySchemeSettings", 	"Scheme", 	"MapButton" )
		Derma_Hook( lbl, 	"PerformLayout", 		"Layout", 	"MapButton" )
		
		lbl:SetTall( 154 )
		lbl:SetWide( 256 )
			
		lbl.WantName = mapname
		lbl.NumVotes = 0
		lbl.DoClick = function() 
			if GetGlobalFloat( "VoteEndTime", 0 ) - CurTime() <= 0 then 
				return
			end
			RunConsoleCommand( "votemap", mapname )
		end
		
		-- IMAGES! yay
		local Image = vgui.Create("DImage", lbl)
		if file.Exists("maps/thumb/"..mapname..".png", "GAME") then
			-- Setting the image does not require a parent directory thing
			Image:SetImage("maps/thumb/"..mapname..".png")
		else
			Image:SetImage("maps/thumb/noicon.png")
		end
		
		Image:SizeToContents()
		Image:SetSize(math.min(Image:GetWide(), 128), math.min(Image:GetTall(), 128))
		Image:SetPos( (lbl:GetWide() * 0.5) - 64, 4 )
		self.ctrlList:AddItem( lbl )
	end
end

function PANEL:ResetPeeps()

	for i=1, game.MaxPlayers() do
		self.Peeps[i]:SetPos( math.random( 0, 600 ), -16 )
		self.Peeps[i]:SetVisible( false )
		self.Peeps[i].strVote = nil
	end

end

function PANEL:FindWantBar( name )

	for k, v in pairs( self.ctrlList:GetItems() ) do
		if ( v.WantName == name ) then return v end
	end

end

function PANEL:PeepThink( peep, ent )

	if ( !IsValid( ent ) ) then 
		peep:SetVisible( false )
		return
	end
	
	peep:SetTooltip( ent:Nick() )
	peep:SetMouseInputEnabled( true )
	
	if ( !peep.strVote ) then
		peep:SetVisible( true )
		peep:SetPos( math.random( 0, 600 ), -16 )
		if ( ent == LocalPlayer() ) then
			peep:SetImage( "icon16/star.png" )
		end
	end

	peep.strVote = ent:GetNWString( "Wants", "" )
	local bar = self:FindWantBar( peep.strVote ) 
	if ( IsValid( bar ) ) then
	
		bar.NumVotes = bar.NumVotes + 1
		local vCurrentPos = Vector( peep.x, peep.y, 0 )
		local vNewPos = Vector( (bar.x + bar:GetWide()) - 15 * bar.NumVotes - 4, bar.y + ( bar:GetTall() * 0.5 - 8 ), 0 )
	
		if ( !peep.CurPos || peep.CurPos != vNewPos ) then
		
			peep:MoveTo( vNewPos.x, vNewPos.y, 0.2 )
			peep.CurPos = vNewPos
			
		end
		
	end

end

function PANEL:Think()

	local Seconds = GetGlobalFloat( "VoteEndTime", 0 ) - CurTime()
	if ( Seconds < 0 ) then Seconds = 0 end
	
	self.lblCountDown:SetText( Format( "%i", Seconds ) )
	
	for k, v in pairs( self.ctrlList:GetItems() ) do
		v.NumVotes = 0
	end
	
	for i=1, game.MaxPlayers() do
		self:PeepThink( self.Peeps[i], Entity(i) )
	end

end

function PANEL:Paint()

	Derma_DrawBackgroundBlur( self )
		
	local CenterY = ScrH() / 2.0
	local CenterX = ScrW() / 2.0
	
	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.DrawRect( 0, 0, ScrW(), ScrH() )
	
end

function PANEL:FlashItem( itemname )

	local bar = self:FindWantBar( itemname )
	if ( !IsValid( bar ) ) then return end
	
	timer.Simple( 0.0, function() bar.bgColor = Color( 0, 255, 255 ) surface.PlaySound( "hl1/fvox/blip.wav" ) end )
	timer.Simple( 0.2, function() bar.bgColor = nil end )
	timer.Simple( 0.4, function() bar.bgColor = Color( 0, 255, 255 ) surface.PlaySound( "hl1/fvox/blip.wav" ) end )
	timer.Simple( 0.6, function() bar.bgColor = nil end )
	timer.Simple( 0.8, function() bar.bgColor = Color( 0, 255, 255 ) surface.PlaySound( "hl1/fvox/blip.wav" ) end )
	timer.Simple( 1.0, function() bar.bgColor = Color( 100, 100, 100 ) end )

end
derma.DefineControl( "VoteScreen", "", PANEL, "DPanel" )

local VoteThinger = nil
local function GetVoteScreen()
	RunConsoleCommand("-score")
	if ( IsValid( VoteThinger ) ) then return VoteThinger end

	VoteThinger = vgui.Create( "VoteScreen" )
	return VoteThinger

end
net.Receive( "BeginVote", GetVoteScreen )