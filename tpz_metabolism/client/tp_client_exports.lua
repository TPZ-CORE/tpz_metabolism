
-----------------------------------------------------------
--[[ Exports  ]]--
-----------------------------------------------------------

-- returns the current thirst. 
exports('getThirst', function()
	return GetPlayerData().Thirst
end)

-- returns the current hunger. 
exports('getHunger', function()
	return GetPlayerData().Hunger
end)

-- returns the current stress. 
exports('getStress', function()
	return GetPlayerData().Stress
end)

-- returns the current alcohol. 
exports('getAlcohol', function()
	return GetPlayerData().Alcohol
end)

-- returns the current temperature.
exports('getTemperature', function()
	return GetPlayerData().Temperature
end)