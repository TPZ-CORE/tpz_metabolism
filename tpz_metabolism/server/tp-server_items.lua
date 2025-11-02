local TPZInv = exports.tpz_inventory:getInventoryAPI()

-----------------------------------------------------------
--[[ Base Events ]]--
-----------------------------------------------------------

RegisterServerEvent("tpz_metabolism:removeDurabilityByItemId")
AddEventHandler("tpz_metabolism:removeDurabilityByItemId", function(itemName, removeValue, itemId, removeItem)
    local _source = source

    local durability = TPZInv.getItemDurability(_source, itemName, itemId)

    if durability == nil then
        return
    end

    TPZInv.removeItemDurability(_source, itemName, removeValue, itemId, removeItem)

    if (durability - removeValue) <= 0 then

        Wait(Attributes.Animations["DRINK_LONG_BOTTLE"].delay_duration - 1000)
        TriggerClientEvent("tpz_metabolism:removeAttachedEntity", _source)
    end

end)

-----------------------------------------------------------
--[[ Items Registration  ]]--
-----------------------------------------------------------

Citizen.CreateThread(function()

    for index, itemData in pairs (Items.RegisteredUsableItems) do

        TPZInv.registerUsableItem(index, "tpz_metabolism", function(data)

            local _source = data.source

            TriggerClientEvent("tpz_metabolism:onUsableItemAction", _source, index, data.itemId)
            
            if itemData.CloseInventory then
                TriggerClientEvent('tpz_inventory:closePlayerInventory', _source)
            end

            if itemData.RemoveOnUse then
                TPZInv.removeItem(_source, index, 1, data.itemId)

                if itemData.NotifyOnUse ~= false then
                    SendNotification(_source, itemData.NotifyOnUse, "success")
                end

            elseif not itemData.RemoveOnUse and itemData.Durability.Enabled then

                if tonumber(data.durability) == 0 then 
                    SendNotification(_source, Locales['ITEM_NO_DURABILITY'], "error")
                    return
                end

                if itemData.Action.Animation ~= "DRINK_LONG_BOTTLE" then
                    TPZInv.removeItemDurability(_source, index, itemData.Durability.Value, data.itemId, itemData.Durability.Remove)
                
                    if itemData.NotifyOnUse ~= false then
                        SendNotification(_source, itemData.NotifyOnUse, "success")
                    end

                end
            end

            if itemData.GiveItemOnUse.Enabled then

                if TPZInv.canCarryItem(_source, itemData.GiveItemOnUse.Item, 1) then
                    TPZInv.addItem(_source, itemData.GiveItemOnUse.Item, 1)
                end

            end

        end)
    end
    
end)

