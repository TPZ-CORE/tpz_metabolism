local Prompts     = GetRandomIntInRange(0, 0xffffff)
local PromptsList = {}

-----------------------------------------------------------
--[[ Prompts  ]]--
-----------------------------------------------------------

RegisterPrompts = function()

    for index, tprompt in pairs (Items.PromptKeys) do


		local str      = tprompt.label
		local keyPress = tprompt.key
	
		local _prompt = PromptRegisterBegin()
		PromptSetControlAction(_prompt, keyPress)
		str = CreateVarString(10, 'LITERAL_STRING', str)
		PromptSetText(_prompt, str)
		PromptSetEnabled(_prompt, 1)
		PromptSetVisible(_prompt, 1)
		PromptSetStandardMode(_prompt, 1)
		PromptSetHoldMode(_prompt, tprompt.hold)

		PromptSetGroup(_prompt, Prompts)

		Citizen.InvokeNative(0xC5F428EE08FA7F2C, _prompt, true)
		PromptRegisterEnd(_prompt)
	
		table.insert(PromptsList, {prompt = _prompt, type = index })

    end

end

function GetPromptData()
    return Prompts, PromptsList
end

-----------------------------------------------------------
--[[ Entity Models  ]]--
-----------------------------------------------------------

LoadModel = function(inputModel)
    local model = GetHashKey(inputModel)
 
    RequestModel(model)
 
    while not HasModelLoaded(model) do RequestModel(model)
        Citizen.Wait(10)
    end

end

RemoveEntityProperly = function(entity, objectHash)
	DeleteEntity(entity)
	DeletePed(entity)
	SetEntityAsNoLongerNeeded( entity )

	if objectHash then
		SetModelAsNoLongerNeeded(objectHash)
	end
end

-----------------------------------------------------------
--[[ Other Utilities  ]]--
-----------------------------------------------------------

GetFixedCount = function(type, currentValue, action, value)
	local returnedValue = 0

	if action == "add" then

		currentValue = currentValue + tonumber(value)

		local maximumValue = 100

		if type == "HUNGER" then
			maximumValue = Config.InitialValues.Hunger

		elseif type == 'THIRST' then
			maximumValue = Config.InitialValues.Thirst
		end

		if (currentValue > maximumValue) then
			currentValue = maximumValue
		end

		returnedValue = currentValue

	elseif action == "remove" then

		currentValue = currentValue - tonumber(value)

		if (currentValue <= 0) then
			currentValue = 0
		end

		returnedValue = currentValue

	end

	return returnedValue

end

PlayAnimation = function(ped, anim)
	if not DoesAnimDictExist(anim.dict) then
		return
	end

	RequestAnimDict(anim.dict)

	while not HasAnimDictLoaded(anim.dict) do
		Wait(0)
	end

	TaskPlayAnim(ped, anim.dict, anim.name, 1.0, 1.0, -1, anim.flag, 0, false, false, false, '', false)

	RemoveAnimDict(anim.dict)
end

ScreenEffect = function(effect, time)
	AnimpostfxPlay(effect)
	Citizen.Wait(time)
	AnimpostfxStop(effect)
end