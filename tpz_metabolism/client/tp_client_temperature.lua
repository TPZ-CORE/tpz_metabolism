-----------------------------------------------------------
--[[ Temperature System  ]]--
-----------------------------------------------------------

-- Temperature Counting System which includes Clothing System.
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

		local PlayerData = GetPlayerData()
		
		if PlayerData.Loaded then
			local player    = PlayerPedId()
			local coords    = GetEntityCoords(player)

			local extraTemp = 0

			-- Body Temperatures (Increasing Temp)
			if Config.ClothingExtraTemperature then

				for index, cloth in pairs(Config.ClothingListHashes) do

					local isWearingCloth = Citizen.InvokeNative(0xFB4891BD7578CDC1, player, cloth.hash)

					if isWearingCloth then
						extraTemp = extraTemp + cloth.temp
					end

				end

			end
	
			PlayerData.Temperature = math.floor(GetTemperatureAtCoords(coords) + extraTemp)

			if PlayerData.ExtraTemperatureType == "add" then
				PlayerData.Temperature = PlayerData.Temperature + PlayerData.ExtraTemperature
				
			elseif PlayerData.ExtraTemperatureType == "remove" then
				PlayerData.Temperature = PlayerData.Temperature - PlayerData.ExtraTemperature
			end

			TriggerEvent("tpz_metabolism:getCurrentTemperature", PlayerData.Temperature)

		end

    end
end)

