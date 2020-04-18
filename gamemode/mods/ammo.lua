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
	{ "item_ammo_357", "357" },
	{ "item_ammo_357_large", "357" },
	{ "item_ammo_ar2", "AR2" },
	{ "item_ammo_ar2_large", "AR2" },
	{ "item_ammo_ar2_altfire", "AR2AltFire" },
	{ "item_ammo_crossbow", "XBowBolt" },
	{ "item_ammo_pistol", "Pistol" },
	{ "item_ammo_pistol_large", "Pistol" },
	{ "item_rpg_round", "RPG_Round" },
	{ "item_ammo_smg1", "SMG1" },
	{ "item_ammo_smg1_large", "SMG1" },
	{ "item_ammo_smg1_grenade", "SMG1_Grenade" },
	{ "item_box_buckshot", "Buckshot" },
}

hook.Add( "PlayerCanPickupItem", "limitMaxAmmo", function( ply, item )// TODO: Finish
	local isAmmo = false
	local ammoType = nil
	for k,v in pairs(PickupAmmo) do
		if v[1] == item:GetClass() then
			isAmmo = true
			ammoType = v[2]
			break
		end
	end
	if not isAmmo then return end
	if ply:GetAmmoCount(ammoType) >= ply.activeCharStats.mods.maxAmmo[ammoType] then
		return false
	else
		return true // NEEDS A math.Clamp(addedAmmo, 0, ply.activeCharStats.mods.maxAmmo[ammoType])
	end
end )