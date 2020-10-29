baseMaxAmmo = {
	["Pistol"] = 180,
	["357"] = 36,
	["SMG1"] = 180,
	["AR2"] = 120, // Pulse Rifle
	["Buckshot"] = 24, 
	["XBowBolt"] = 15, // Crossbow
	["Grenade"] = 3,
	["SMG1_Grenade"] = 3,
	["slam"] = 3,
	["RPG_Round"] = 3,
	["AR2AltFire"] = 3, // Pulse Rifle Ball
}

PickupAmmo = {
	["item_ammo_357"] = { "357", 10 },
	["item_ammo_357_large"] = { "357", 20 },
	["item_ammo_ar2"] = { "AR2", 60 },
	["item_ammo_ar2_large"] = { "AR2", 120 },
	["item_ammo_ar2_altfire"] = { "AR2AltFire", 1 },
	["item_ammo_crossbow"] = { "XBowBolt", 4 },
	["item_ammo_pistol"] = { "Pistol", 20 },
	["item_ammo_pistol_large"] = { "Pistol", 40 },
	["item_rpg_round"] = { "RPG_Round", 1 },
	["item_ammo_smg1"] = { "SMG1", 20 },
	["item_ammo_smg1_large"] = { "SMG1", 40 },
	["item_ammo_smg1_grenade"] = { "SMG1_Grenade", 1 },
	["item_box_buckshot"] = { "Buckshot", 12 },
}

hook.Add( "PlayerCanPickupItem", "limitMaxAmmo", function( ply, item )
	local isAmmo = false
	local ammoType = nil
	local itemType = nil
	for k,v in pairs(PickupAmmo) do
		if k == item:GetClass() then
			itemType = k
			isAmmo = true
			ammoType = v[1]
			break
		end
	end
	if not isAmmo then return end
	if ply:GetAmmoCount(ammoType) <= ply.activeCharStats.mods.maxAmmo[ammoType] then
		ply:SetAmmo( math.Clamp( ply:GetAmmoCount(ammoType)+PickupAmmo[itemType][2], 0, ply.activeCharStats.mods.maxAmmo[ammoType] ), ammoType )
		item:Remove()
	end
	return false
end )