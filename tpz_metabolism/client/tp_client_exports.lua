
-----------------------------------------------------------
--[[ Exports  ]]--
-----------------------------------------------------------

-- returns the current thirst. 
exports('getThirst', function()
	return ClientData.Thirst
end)

-- returns the current hunger. 
exports('getHunger', function()
	return ClientData.Hunger
end)

-- returns the current stress. 
exports('getStress', function()
	return ClientData.Stress
end)

-- returns the current alcohol. 
exports('getAlcohol', function()
	return ClientData.Alcohol
end)

-- returns the current temperature.
exports('getTemperature', function()
	return ClientData.Temperature
end)