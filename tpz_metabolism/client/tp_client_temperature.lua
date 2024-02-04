-----------------------------------------------------------
--[[ Temperature System  ]]--
-----------------------------------------------------------

-- Temperature Counting System which includes Clothing System.
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)

		if ClientData.Loaded then
			local player    = PlayerPedId()
			local coords    = GetEntityCoords(player)

			local extraTemp = 0
			local finished  = false

			-- Body Temperatures (Increasing Temp)
			if Config.ClothingExtraTemperature then

				for index, cloth in pairs(Config.ClothingListHashes) do

					local isWearingCloth = Citizen.InvokeNative(0xFB4891BD7578CDC1, player, cloth.hash)

					if isWearingCloth then
						extraTemp = extraTemp + cloth.temp
					end

					if next(Config.ClothingListHashes, index) == nil then
						finished = true
					end

				end
			else
				finished = true
			end

			while not finished do
				Wait(150)
			end
	
			ClientData.Temperature = math.floor(GetTemperatureAtCoords(coords) + extraTemp)

			if ClientData.ExtraTemperatureType == "add" then
				ClientData.Temperature = ClientData.Temperature + ClientData.ExtraTemperature
				
			elseif ClientData.ExtraTemperatureType == "remove" then
				ClientData.Temperature = ClientData.Temperature - ClientData.ExtraTemperature
			end

			TriggerEvent("tpz_metabolism:getCurrentTemperature", ClientData.Temperature)

		end

    end
end)

