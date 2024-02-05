-----------------------------------------------------------
--[[ Temperature, Thirst & Hunger Damage Modifiers  ]]--
-----------------------------------------------------------

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1000)

		if ClientData.Loaded then

			-- Hunger & Thirst Damage Modifiers

			if (ClientData.Hunger <= Config.HungerStripeValue) or (ClientData.Thirst <= Config.ThirstStripeValue) then
				local player  = PlayerPedId()
				local health  = GetEntityHealth(player)

				local removedHealthValue = health - Config.HealthDamageValue

				PlayPain(player, 9, 1, true, true)

				if removedHealthValue <= 0 then

					removedHealthValue = 0
					Citizen.InvokeNative(0x697157CED63F18D4, player, 500000, false, true, true) -- ApplyDamageToPed
				end

				SetEntityHealth(player, removedHealthValue)
			end

			if (Config.MinTemperatureDamage and ClientData.Temperature <= Config.MinTemperature) then

				local player  = PlayerPedId()
				local health  = GetEntityHealth(player)

				local removedHealthValue = health - Config.MinTemperatureDamage

				PlayPain(player, 9, 1, true, true)

				if removedHealthValue > 0 and removedHealthValue <= 50 then
					Citizen.InvokeNative(0xa4d3a1c008f250df, 6)
					Citizen.InvokeNative(0x4102732DF6B4005F,"MP_Downed", 0, true)
				end

				if removedHealthValue <= 0 then

					removedHealthValue = 0
					Citizen.InvokeNative(0x697157CED63F18D4, player, 500000, false, true, true) -- ApplyDamageToPed

					if Citizen.InvokeNative(0x4A123E85D7C4CA0B,"MP_Downed") then 
						Citizen.InvokeNative(0xB4FD7446BAB2F394,"MP_Downed")
					end

				end

				SetEntityHealth(player, removedHealthValue)
			end

		end
	end
end)


-----------------------------------------------------------
--[[ Thirst & Hunger Drain Modifiers  ]]--
-----------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		
		Wait(Config.TimeRateRepeat * 1000)

		local player = PlayerPedId()
		local isDead = IsEntityDead(player)

		if ClientData.Loaded and not isDead then

			local removeThirstValue = 0
			local removeHungerValue = 0

			if IsPedOnFoot(player) and ( IsPedRunning(player) or IsPedSprinting(player) ) then

				removeThirstValue = Config.ThirstDrainRunning
				removeHungerValue = Config.HungerDrainRunning

			elseif IsPedWalking(player) then
				
				removeThirstValue = Config.ThirstDrainWalking
				removeHungerValue = Config.HungerDrainWalking

			else

				removeThirstValue = Config.ThirstDrainIdle
				removeHungerValue = Config.HungerDrainIdle
			end

			if (ClientData.Temperature <= Config.MinTemperature) then
					
				if Config.MinTemperatureDrainThirst > 0 then
					removeThirstValue = removeThirstValue + Config.MinTemperatureDrainThirst
				end

			elseif (ClientData.Temperature >= Config.MaxTemperature) then

				if Config.MaxTemperatureDrainThirst > 0 then
					removeThirstValue = removeThirstValue + Config.MaxTemperatureDrainThirst
				end

			end

			local returnedThirstValue = GetFixedCount("THIRST", ClientData.Thirst, 'remove', removeThirstValue)
			local returnedHungerValue = GetFixedCount("HUNGER", ClientData.Hunger, 'remove', removeHungerValue)

			ClientData.Thirst = returnedThirstValue
			ClientData.Hunger = returnedHungerValue

			TriggerServerEvent("tpz_metabolism:updateMetabolismType", "THIRST", returnedThirstValue)
			TriggerServerEvent("tpz_metabolism:updateMetabolismType", "HUNGER", returnedHungerValue)

			TriggerEvent("tpz_metabolism:getCurrentMetabolismValues", ClientData.Hunger, ClientData.Thirst, ClientData.Stress, ClientData.Alcohol)

		end

	end


end)

-----------------------------------------------------------
--[[ Notifications  ]]--
-----------------------------------------------------------

Citizen.CreateThread(function ()
	while true do
		Wait(60000 * Config.Notifications.NotificationWarningDelay)

		if ClientData.Loaded then
			
			-- Cold
			if ClientData.Temperature <= Config.MinTemperature and Config.Notifications.Temperature.Cold.Enabled then

				local notifyData = Config.Notifications.Temperature.Cold

				TriggerEvent("tpz_core:sendLeftNotification", notifyData.NotifyTitle, notifyData.Notify, "rpg_textures", "rpg_cold", notifyData.Cooldown)
			end

			-- Hot
			if ClientData.Temperature >= Config.MaxTemperature and Config.Notifications.Temperature.Hot.Enabled then

				local notifyData = Config.Notifications.Temperature.Hot

				TriggerEvent("tpz_core:sendLeftNotification", notifyData.NotifyTitle, notifyData.Notify, "rpg_textures", "rpg_hot", notifyData.Cooldown)
			end

			-- Hunger
			if ClientData.Hunger <= Config.Notifications.Hunger.Value and Config.Notifications.Hunger.Enabled then

				local notifyData = Config.Notifications.Hunger

				TriggerEvent("tpz_core:sendLeftNotification", notifyData.NotifyTitle, notifyData.Notify, "rpg_textures", "rpg_wounded", notifyData.Cooldown)
			end

			-- Thirst
			if ClientData.Thirst <= Config.Notifications.Thirst.Value and Config.Notifications.Thirst.Enabled then

				local notifyData = Config.Notifications.Thirst

				TriggerEvent("tpz_core:sendLeftNotification", notifyData.NotifyTitle, notifyData.Notify, "rpg_textures", "rpg_wounded", notifyData.Cooldown)
			end

			-- Stress
			if ClientData.Stress >= Config.Notifications.Stress.Value and Config.Notifications.Stress.Enabled then

				local notifyData = Config.Notifications.Stress

				TriggerEvent("tpz_core:sendLeftNotification", notifyData.NotifyTitle, notifyData.Notify, "rpg_textures", "rpg_wounded", notifyData.Cooldown)
			end

		end
	end
end)

-----------------------------------------------------------
--[[ Stress  ]]--
-----------------------------------------------------------

-- The following task is running every 1 second and removing cooldown if is active.
Citizen.CreateThread(function()

	while true do
		Wait(1000)

		if ClientData.StressCooldown > 0 then

			ClientData.StressCooldown = ClientData.StressCooldown - 1

			if ClientData.StressCooldown < 0 then
				ClientData.StressCooldown = 0
			end
			
		end

	end

end)

-----------------------------------------------------------
--[[ Drunk / Alcohol System ]]--
-----------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        Wait(1000 * Config.AlcoholRemoveByTime)

		if ClientData.Loaded and ClientData.Alcohol > 0 then

			local player = PlayerPedId()

			-- Alcohol Remove by time system.
			ClientData.Alcohol = ClientData.Alcohol - Config.AlcoholRemoveByTimeValue

			if ClientData.Alcohol <= 0 then
				ClientData.Alcohol = 0
			end

			-- If player alcohol is lower than the consider amount, we remove the drunkness.
			if ClientData.Alcohol < Config.AlcoholConsiderDrunk then
				Citizen.InvokeNative(0x406CCF555B04FAD3 , player, 1, 0.0)
			end
		
			if ClientData.Alcohol >= Config.AlcoholConsiderDrunk and ClientData.Alcohol < Config.AlcoholConsiderVeryDrunk then
				Citizen.InvokeNative(0x406CCF555B04FAD3 , player, 1, 0.5)
			end

			if ClientData.Alcohol >= Config.AlcoholConsiderVeryDrunk then
				Citizen.InvokeNative(0x406CCF555B04FAD3 , player, 1, 1.0)
			end
			
		end
	end

end)

-----------------------------------------------------------
--[[ Sprinting / Running Systems  ]]--
-----------------------------------------------------------

-- Decreasing stamina value while sprinting.
if Config.RealisticSprintStaminaDescrease then

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
	
			local player = PlayerPedId()
	
			if IsPedOnFoot(player) then
				
				local stamina = Citizen.InvokeNative(0x36731AC041289BB1, player, 1) --ACTUAL STAMINA CORE GETTER
	
				if (not stamina) or (stamina and tonumber(stamina) <= 5) or IsEntityAttachedToAnyPed(player) then
					DisableControlAction(0, 0x8FFC75D6, true)
				end
				
				if IsPedSprinting(player) then
					Citizen.InvokeNative(0xC3D4B754C0E86B9E, player, -0.01)
				end
				
			else
				Citizen.Wait(1000)
			end
	
		end
		
	end)

end

-- Disable sprinting / running while being drunk.
if Config.DisablePlayerRunWhileDrunk then

	Citizen.CreateThread(function()
		while true do
			Wait(0)

			if ClientData.Loaded and ClientData.Alcohol >= Config.AlcoholConsiderDrunk then
				DisableControlAction(0, 0x8FFC75D6, true)
			else
				Wait(1000)
			end
		end
	end)

end
