function DrawLevels()
	if LocalPlayer():GetNWBool("IsPlayingGame", false) then
		surface.SetDrawColor( 100,100,100,100 )
		surface.DrawRect( ScrW()/2-250, ScrH()-70, 500, 65 )//background

		surface.SetDrawColor( 0,255,0,100 )
		surface.DrawRect( ScrW()/2-250, ScrH()-70, math.Clamp( ( (LocalPlayer():GetModExp()/LocalPlayer():GetModExpNext())*500 ) or 0, 0, 500), 65 )//xp

		draw.SimpleTextOutlined( "EXP: "..tostring( LocalPlayer():GetModExp() or "N/A" ).." / "..tostring( LocalPlayer():GetModExpNext() or "N/A" ), "DermaLarge", ScrW()/2, ScrH()-50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
		draw.SimpleTextOutlined( "Level: "..tostring( LocalPlayer():GetModLevel() or "N/A" ), "DermaLarge", ScrW()/2, ScrH()-20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
	end
end
hook.Add( "HUDPaint", "Draw_ModCombHUD", DrawLevels )