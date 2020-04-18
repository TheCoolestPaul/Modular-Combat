armor = {
	regenSeconds = 20,
	regenAmount = 0,
	max = 100,
}

function plyMeta:GetMaxArmor()
	return self.activeCharStats.mods.armor.max
end

function plyMeta:GetModArmorRegenTime()
	return self.activeCharStats.mods.armor.regenSeconds
end

function plyMeta:GetModArmorRegenAmount()
	return self.activeCharStats.mods.armor.regenAmount
end