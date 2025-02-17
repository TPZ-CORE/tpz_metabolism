
Citizen.CreateThread(function()
	RegisterPrompts()
end)

local AttachedEntity, AttachedEntityModel = nil, nil

local IsVometing = false
-----------------------------------------------------------
--[[ Base Events  ]]--
-----------------------------------------------------------

AddEventHandler('playerDropped', function (reason)
	if AttachedEntity == nil then
		return
	end

	RemoveEntityProperly(AttachedEntity, AttachedEntityModel )
end)

-----------------------------------------------------------
--[[ Events  ]]--
-----------------------------------------------------------

RegisterNetEvent("tpz_metabolism:removeAttachedEntity")
AddEventHandler("tpz_metabolism:removeAttachedEntity", function()
	if AttachedEntity == nil or not DoesEntityExist(AttachedEntity) then
		return
	end

	RemoveEntityProperly(AttachedEntity, AttachedEntityModel )
	ClearPedSecondaryTask(PlayerPedId())

	AttachedEntity      = nil
	AttachedEntityModel = nil
end)

RegisterNetEvent("tpz_metabolism:onUsableItemAction")
AddEventHandler("tpz_metabolism:onUsableItemAction", function(index, itemId)
	local itemData = Items.RegisteredUsableItems[index]

	local player   = PlayerPedId()
	local coords   = GetEntityCoords(player)

	-- There is also an option for an item to not use an object.
	-- In that case, we always check if the object is valid before loading.
	if itemData.Action.Object then
		LoadModel(itemData.Action.Object)
	end

	-- We set the current player weapon to unarmed.
	SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true, 0, false, false) 

	if itemData.Action.Animation == "EAT" then

		local prop      = CreateObject(GetHashKey(itemData.Action.Object), coords.x, coords.y, coords.z + 0.2, true, true, false, false, true)
		local boneIndex = GetEntityBoneIndexByName(player, "SKEL_L_Finger12")

		PlayAnimation(player, Attributes.Animations["EAT"])

		AttachEntityToEntity(prop, player, boneIndex, 0.02, 0.028, 0.001, 15.0, 175.0, 0.0, true, true, false, true, 1, true)

		OnUsableItemAction(index)

		Wait(1000)

		RemoveEntityProperly(prop, GetHashKey(itemData.Action.Object) )

		ClearPedSecondaryTask(player)

	elseif itemData.Action.Animation == "EAT_BOWL_OR_PLATE" then

		LoadModel("p_spoon01x")

		local prop  = CreateObject(GetHashKey(itemData.Action.Object), coords, true, true, false, false, true)
		local spoon = CreateObject(GetHashKey("p_spoon01x"), coords, true, true, false, false, true)

		Citizen.InvokeNative(0x669655FFB29EF1A9, prop, 0, "Stew_Fill", 1.0)
		Citizen.InvokeNative(0xCAAF2BCCFEF37F77, prop, 20)
		Citizen.InvokeNative(0xCAAF2BCCFEF37F77, spoon, 82)

		TaskItemInteraction_2(player, 599184882, prop, GetHashKey("p_bowl04x_stew_ph_l_hand"), -583731576, 1, 0, -1.0)
		TaskItemInteraction_2(player, 599184882, spoon, GetHashKey("p_spoon01x_ph_r_hand"), -583731576, 1, 0, -1.0)

		Citizen.InvokeNative(0xB35370D5353995CB, player, -583731576, 1.0)

		OnUsableItemAction(index)

		Citizen.Wait(Config.EatBowlAnimDuration)

		RemoveEntityProperly(prop, GetHashKey(itemData.Action.Object) )
		RemoveEntityProperly(spoon, GetHashKey("p_spoon01x") )
		
		ClearPedSecondaryTask(player)

	elseif itemData.Action.Animation == "EAT_BERRIES" then

		PlayAnimation(player, Attributes.Animations["EAT_BERRIES"])

		Wait(2500)

		OnUsableItemAction(index)

		ClearPedTasks(player)

	elseif itemData.Action.Animation == "DRINK_ONCE" then

		local prop      = CreateObject(GetHashKey(itemData.Action.Object), coords.x, coords.y, coords.z + 0.2, true, true, false, false, true)
		local boneIndex = GetEntityBoneIndexByName(player, 'MH_L_HandSide')

		PlayAnimation(player, Attributes.Animations["DRINK_ONCE"] )
		AttachEntityToEntity(prop, player, boneIndex, 0.03, -0.01, -0.03, 20.0, -0.0, 0.0, true, true, false, true, 1, true)

		OnUsableItemAction(index)

		Wait(5000)

		RemoveEntityProperly(prop, GetHashKey(itemData.Action.Object) )
		ClearPedSecondaryTask(player)

	elseif itemData.Action.Animation == "DRINK_LONG_BOTTLE" then

		local entity = CreateObject(GetHashKey(itemData.Action.Object), coords , 0.2, true, true, false, false, true)

		local attachmentData = itemData.ObjectAttachment

        local boneIndex = GetEntityBoneIndexByName(player, attachmentData.Attachment)
                
        AttachEntityToEntity(entity, player, boneIndex, 
        attachmentData.x, attachmentData.y, attachmentData.z, attachmentData.xRot, attachmentData.yRot, attachmentData.zRot, 
        true, true, false, true, 1, true)

		AttachedEntity = entity
		AttachedEntityModel = GetHashKey(itemData.Action.Object)

		Citizen.CreateThread(function() 

			while DoesEntityExist(entity) do

				Wait(0)

				if not IsVometing then

                    local promptGroup, promptList = GetPromptData()

					local label = CreateVarString(10, 'LITERAL_STRING', itemData.Label )
					PromptSetActiveGroupThisFrame(promptGroup, label)
	
					for i, prompt in pairs (promptList) do
	
						if PromptHasHoldModeCompleted(prompt.prompt) then
	
							if prompt.type == 'USE' then
								PlayAnimation(player, Attributes.Animations["DRINK_LONG_BOTTLE"])
	
								Wait(Attributes.Animations["DRINK_LONG_BOTTLE"].delay_duration)
	
								OnUsableItemAction(index, itemId)
	
							elseif prompt.type == 'CANCEL' then
	
								RemoveEntityProperly(entity, GetHashKey(itemData.Action.Object) )
								ClearPedSecondaryTask(player)
	
								AttachedEntity      = nil
								AttachedEntityModel = nil
	
								Wait(1000)
							end
	
						end
					end

				end

			end
		
		end)


		Citizen.Wait(Config.DrinkBottleAnimDuration)

		if DoesEntityExist(entity) then

			RemoveEntityProperly(entity, GetHashKey(itemData.Action.Object) )
			ClearPedSecondaryTask(player)

			AttachedEntity      = nil
			AttachedEntityModel = nil
		end

	elseif itemData.Action.Animation == "DRINK_MUG" then

		local prop = CreateObject(GetHashKey(itemData.Action.Object), coords, true, true, true)

		TaskItemInteraction_2(player, -1199896558, prop, GetHashKey('p_mugCOFFEE01x_ph_r_hand'), GetHashKey('DRINK_COFFEE_HOLD'), 3, 0, -1.0)
		
		OnUsableItemAction(index)

		Citizen.Wait(Config.DrinkCupAnimDuration)

		RemoveEntityProperly(prop, GetHashKey(itemData.Action.Object) )
		ClearPedSecondaryTask(player)

	end

	

end)

-----------------------------------------------------------
--[[ Functions ]]--
-----------------------------------------------------------

OnUsableItemAction = function (index, itemId)
	local PlayerData = GetPlayerData()
	local itemData   = Items.RegisteredUsableItems[index]

	-- Temperature
	if itemData.Temperature.Enabled then
		PlayerData.ExtraTemperatureType      = itemData.Temperature.Type
		PlayerData.ExtraTemperature          = itemData.Temperature.Value
		PlayerData.ExtraTemperatureDuration  = itemData.Temperature.Duration
	end

	local metabolismData = itemData.Metabolism

	if metabolismData.Hunger.Value > 0 then

		local returnedValue = GetFixedCount("HUNGER", PlayerData.Hunger, metabolismData.Hunger.Type, metabolismData.Hunger.Value)
		PlayerData.Hunger = returnedValue
		TriggerServerEvent("tpz_metabolism:updateMetabolismType", "HUNGER", returnedValue)
	end

	if metabolismData.Thirst.Value > 0 then

		local returnedValue = GetFixedCount("THIRST", PlayerData.Thirst, metabolismData.Thirst.Type, metabolismData.Thirst.Value)
		PlayerData.Thirst = returnedValue
		TriggerServerEvent("tpz_metabolism:updateMetabolismType", "THIRST", returnedValue)
	end

	if metabolismData.Stress.Value > 0 then

		local returnedValue = GetFixedCount("STRESS", PlayerData.Stress, metabolismData.Stress.Type, metabolismData.Stress.Value)
		PlayerData.Stress = returnedValue
		TriggerServerEvent("tpz_metabolism:updateMetabolismType", "STRESS", returnedValue)

	end

	if itemData.Alcohol.Enabled and itemData.Alcohol.Value > 0 then

		local returnedValue = GetFixedCount("ALCOHOL", PlayerData.Alcohol, 'add', itemData.Alcohol.Value)
		PlayerData.Alcohol = returnedValue
		TriggerServerEvent("tpz_metabolism:updateMetabolismType", "ALCOHOL", returnedValue)

		-- For normal / medium alcohol values, we do only vomits.
		if PlayerData.Alcohol >= Config.AlcoholConsiderDrunk and PlayerData.Alcohol < Config.AlcoholConsiderVeryDrunk then

			local vomitChance = math.random(1, 99)

			if vomitChance >= 60 then
				IsVometing = true

				local randomVomit = math.random(1, 3)
				PlayAnimation(PlayerPedId(), Attributes.Vomits["VOMIT_" .. randomVomit] )

				IsVometing = false
			end

		end

		-- If the player has Alcohol
		if PlayerData.Alcohol >= Config.AlcoholConsiderVeryDrunk then

			local random = math.random(1, 3)

			if random == 1 then
				-- to do nothing

			elseif random == 2 then
				IsVometing = true

				local randomVomit = math.random(1, 3)
				PlayAnimation(PlayerPedId(), Attributes.Vomits["VOMIT_" .. randomVomit] )

				IsVometing = false

			elseif random == 3 then
				RemoveEntityProperly(entity, GetHashKey(itemData.Action.Object) )
				ClearPedTasksImmediately(PlayerPedId())

				AttachedEntity      = nil
				AttachedEntityModel = nil

				SetPedToRagdoll(PlayerPedId(), 60000, 60000, 0, 0, 0, 0)

				ScreenEffect("PlayerDrunk01", 5000)
				ScreenEffect("PlayerDrunk01_PassOut", 30000)
			end

		end

	end

	if itemData.Durability.Enabled then
		TriggerServerEvent("tpz_metabolism:removeDurabilityByItemId", index, itemData.Durability.Value, itemId, itemData.Durability.Remove)
	end

	TriggerEvent("tpz_metabolism:setMetabolismCoreValue", "HEALTH", metabolismData.InnerCoreHealth, metabolismData.InnerCoreHealthGold, metabolismData.OuterCoreHealthGold )
	TriggerEvent("tpz_metabolism:setMetabolismCoreValue", "STAMINA", metabolismData.InnerCoreStamina, metabolismData.InnerCoreStaminaGold, metabolismData.OuterCoreStaminaGold )

	TriggerEvent("tpz_metabolism:getCurrentMetabolismValues", PlayerData.Hunger, PlayerData.Thirst, PlayerData.Stress, PlayerData.Alcohol)

end

-----------------------------------------------------------
--[[ Threads ]]--
-----------------------------------------------------------

Citizen.CreateThread(function() 

	while true do

		Wait(1000)

		if AttachedEntity then

			-- Prevent players from opening the inventory while holding an object to perform animation actions.
			TriggerEvent('tpz_inventory:closePlayerInventory')

			local player = PlayerPedId()
			local isDead = IsEntityDead(player)

			-- Remove the attached entity properly if the player is dead.
			if isDead then
				RemoveEntityProperly(AttachedEntity, AttachedEntityModel )
			end
		end

	end

end)