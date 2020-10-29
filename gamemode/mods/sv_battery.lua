battrey = {
	regenSeconds = 5,
	regenAmount = 1,
	max = 100,
}

function plyMeta:GetMaxBattery()
	return self.activeCharStats.mods.battery.max
end

function plyMeta:GetModBatteryRegenTime()
	return self.activeCharStats.mods.batery.regenSeconds
end

function plyMeta:GetModBatteryRegenAmount()
	return self.activeCharStats.mods.batery.regenAmount
end