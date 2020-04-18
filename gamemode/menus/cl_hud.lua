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

		// BEGIN: Admin ESP
		if LocalPlayer():GetNWBool("ModCombAdminPlayerESP", false) and ( LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() ) then
			for _,v in ipairs ( player.GetAll() ) do
				if v:Nick() != LocalPlayer():Nick() then
					local pos = v:GetPos() + Vector(0,0,90)
					pos = pos:ToScreen()
					if v:Health() > 0 then
						color = Color(255,255,255,255)
					elseif v:Health() < 1 then
						color = Color(0,0,0,255)
						draw.DrawText("*Dead*", "DermaDefault", pos.x, pos.y + 10, color,1)
					end
					draw.DrawText(v:Nick(), "DermaDefault", pos.x, pos.y - 10, color,1)
				end
			end
		end
		if LocalPlayer():GetNWBool("ModCombAdminSpawnersESP", false) and ( LocalPlayer():IsAdmin() or LocalPlayer():IsSuperAdmin() ) then
			for _,v in ipairs ( ents.GetAll() ) do
				if IsSpawner(v) then
					local pos = v:GetPos() + Vector(0,0,10)
					pos = pos:ToScreen()
					draw.DrawText(v:GetClass(), "DermaDefault", pos.x, pos.y - 10, color,1)
				end
			end
		end
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
