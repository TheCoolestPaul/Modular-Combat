function DrawLevels()
	if LocalPlayer():GetNWBool("ShouldShowHUD", false) then
		// BEGIN: EXP/LEVEL
		surface.SetDrawColor( 100,100,100,100 )
		surface.DrawRect( ScrW()/2-250, ScrH()-70, 500, 65 )//background

		surface.SetDrawColor( 0,255,0,100 )
		surface.DrawRect( ScrW()/2-250, ScrH()-70, math.Clamp( ( (LocalPlayer():GetNWInt("EXP", 0)/LocalPlayer():GetNWInt("EXPNext", 100))*500 ) or 0, 0, 500), 65 )//xp

		draw.SimpleTextOutlined( "EXP: "..tostring( LocalPlayer():GetNWInt("EXP", 0) ).." / "..tostring( LocalPlayer():GetNWInt("EXPNext", 100) ), "DermaLarge", ScrW()/2, ScrH()-50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
		draw.SimpleTextOutlined( "Level: "..tostring( LocalPlayer():GetNWInt("Level", 1) ), "DermaLarge", ScrW()/2, ScrH()-20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )


		// BEGIN: Health

		// BEGIN: Armor

		// BEGIN: HEV Battery
	end
end
hook.Add( "HUDPaint", "Draw_ModCombHUD", DrawLevels )

--local HUDtoHide = {
	--["CHudHealth"] = true,
	--["CHudBattery"] = true,
	--["CHudSuitPower"] = true,
--}
--hook.Add( "HUDShouldDraw", "HideHUD", function( name )
--	if ( HUDtoHide[ name ] ) then return false end
--end )
