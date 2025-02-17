
local PlayerData = {
	Loaded                    = false,

	Thirst                    = Config.InitialValues.Thirst, 
	Hunger                    = Config.InitialValues.Hunger, 
	Stress                    = 0,
	StressCooldown            = 0,
	Alcohol                   = 0,

	Temperature               = 0,

	ExtraTemperatureType      = nil,
	ExtraTemperature          = 0,
	ExtraTemperatureDuration  = 0,
}

-----------------------------------------------------------
--[[ Functions  ]]--
-----------------------------------------------------------

function GetPlayerData()
	return PlayerData
end

-----------------------------------------------------------
--[[ Base Events  ]]--
-----------------------------------------------------------

-- @tpz_core:isPlayerReady : After selecting a character, we request the player metabolism data.
AddEventHandler("tpz_core:isPlayerReady", function()
    Wait(2000)

	TriggerServerEvent("tpz_metabolism:requestPlayerMetabolism")

end)

if Config.DevMode then

	Citizen.CreateThread(function ()
		Wait(2000)
		TriggerServerEvent("tpz_metabolism:requestPlayerMetabolism")
	end)
	
end

-----------------------------------------------------------
--[[ General Events  ]]--
-----------------------------------------------------------

RegisterNetEvent("tpz_metabolism:isLoaded")
AddEventHandler("tpz_metabolism:isLoaded", function ()
	-- todo - nothing (Can be used for HUD)
end)

RegisterNetEvent("tpz_metabolism:getCurrentMetabolismValues")
AddEventHandler("tpz_metabolism:getCurrentMetabolismValues", function (hunger, thirst, stress, alcohol)
	-- todo - nothing (Can be used for HUD or any other scripts)
end)

RegisterNetEvent("tpz_metabolism:getCurrentTemperature")
AddEventHandler("tpz_metabolism:getCurrentTemperature", function (temperature)
	-- todo - nothing (Can be used for HUD or any other scripts)
end)


RegisterNetEvent("tpz_metabolism:requestMetabolismData")
AddEventHandler("tpz_metabolism:requestMetabolismData", function ()
	TriggerEvent("tpz_metabolism:getCurrentMetabolismValues", PlayerData.Hunger, PlayerData.Thirst, PlayerData.Stress, PlayerData.Alcohol)
end)

RegisterNetEvent("tpz_metabolism:registerPlayerMetabolism")
AddEventHandler("tpz_metabolism:registerPlayerMetabolism", function(hunger, thirst, stress, alcohol)

	PlayerData.Hunger  = hunger
	PlayerData.Thirst  = thirst
	PlayerData.Stress  = stress
	PlayerData.Alcohol = alcohol

	Wait(1500)

	PlayerData.Loaded = true

	TriggerEvent("tpz_metabolism:isLoaded")
	TriggerEvent("tpz_metabolism:getCurrentMetabolismValues", PlayerData.Hunger, PlayerData.Thirst, PlayerData.Stress, PlayerData.Alcohol)
end)

-----------------------------------------------------------
--[[ Update Events  ]]--
-----------------------------------------------------------

-- @setMetabolismValue (Update Metabolism Values, such as Hunger, Thirst, Stress & Alcohol)
RegisterNetEvent("tpz_metabolism:setMetabolismValue")
AddEventHandler("tpz_metabolism:setMetabolismValue", function (type, action, value)

	if type == "HUNGER" then
		
		local returnedValue = GetFixedCount("HUNGER", PlayerData.Hunger, action, tonumber(value))
		PlayerData.Hunger = returnedValue

		TriggerServerEvent("tpz_metabolism:updateMetabolismType", "HUNGER", returnedValue)

	elseif type == "THIRST" then
		
		local returnedValue = GetFixedCount("THIRST", PlayerData.Thirst, action, tonumber(value))
		PlayerData.Thirst = returnedValue

		TriggerServerEvent("tpz_metabolism:updateMetabolismType", "THIRST", returnedValue)

	elseif type == "STRESS" then
		
		local returnedValue = GetFixedCount("STRESS", PlayerData.Stress, action, tonumber(value))
		PlayerData.Stress = returnedValue

		TriggerServerEvent("tpz_metabolism:updateMetabolismType", "STRESS", returnedValue)

	elseif type == "ALCOHOL" then
		
		local returnedValue = GetFixedCount("ALCOHOL", PlayerData.Alcohol, action, tonumber(value))
		PlayerData.Alcohol = returnedValue

		TriggerServerEvent("tpz_metabolism:updateMetabolismType", "ALCOHOL", returnedValue)

	end
	
	TriggerEvent("tpz_metabolism:getCurrentMetabolismValues", PlayerData.Hunger, PlayerData.Thirst, PlayerData.Stress, PlayerData.Alcohol)

end)

-- @setMetabolismCoreValue (Updating Core Values)
RegisterNetEvent("tpz_metabolism:setMetabolismCoreValue")
AddEventHandler("tpz_metabolism:setMetabolismCoreValue", function (type, innerValue, innerGoldValue, outerGoldValue)
	local player    = PlayerPedId()

	if type == "STAMINA" then

		if innerValue and innerValue > 0 then

			local currentStamina  = Citizen.InvokeNative(0x36731AC041289BB1, player, 1)
			local newStaminaValue = currentStamina + tonumber(innerValue)
			
			if (newStaminaValue > 100) then
				newStaminaValue = 100
			end

			Citizen.InvokeNative(0xC6258F41D86676E0, player, 1, newStaminaValue)

		end

		if (innerGoldValue ~= 0.0) then
			Citizen.InvokeNative(0x4AF5A4C7B9157D14, player, 1, innerGoldValue, true)
		end

		if (outerGoldValue ~= 0.0) then
			Citizen.InvokeNative(0xF6A7C08DF2E28B28, player, 1, outerGoldValue, true)
		end

	elseif type == "HEALTH" then

		if innerValue and innerValue > 0 then

			local currentHealth   = Citizen.InvokeNative(0x36731AC041289BB1, player, 0) 
			local newHealthValue  = currentHealth + tonumber(innerValue)
			
			if (newHealthValue > 100) then
				newHealthValue = 100
			end

			Citizen.InvokeNative(0xC6258F41D86676E0, player, 0, newHealthValue)

		end

		if (innerGoldValue ~= 0.0) then
			Citizen.InvokeNative(0x4AF5A4C7B9157D14, player, 0, innerGoldValue, true)
		end

		if (outerGoldValue ~= 0.0) then
			Citizen.InvokeNative(0xF6A7C08DF2E28B28, player, 0, outerGoldValue, true)
		end

	end


end)

