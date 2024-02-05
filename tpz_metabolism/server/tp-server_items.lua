local TPZInv      = exports.tpz_inventory:getInventoryAPI()

-----------------------------------------------------------
--[[ Items Registration  ]]--
-----------------------------------------------------------

-- @param source     - returns the player source.
-- @param item       - returns the item name.
-- @param itemId     - returns the itemId (itemId exists only for non-stackable items) otherwise it will return as "0"
-- @param id         - returns the item id which is located in the tpz_items table.
-- @param label      - returns the item label name.
-- @param weight     - returns the item weight.
-- @param durability - returns the durability (exists only for non-stackable items).
-- @param metadata   - returns the metadata that you have created on the given item.


AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end

    for index, itemData in pairs (Items.RegisteredUsableItems) do

        TPZInv.registerUsableItem(index, "tpz_metabolism", function(data)

            local _source = data.source

            TriggerClientEvent("tpz_metabolism:onUsableItemAction", _source, index, data.itemId)
            
            if itemData.CloseInventory then
                TriggerClientEvent('tpz_inventory:closePlayerInventory', _source)
            end

            if itemData.RemoveOnUse then
                TPZInv.removeItem(_source, index, 1, data.itemId)

                SendNotification(_source, itemData.NotifyOnUse, "success")

            elseif not itemData.RemoveOnUse and itemData.Durability.Enabled then

                if itemData.Action.Animation ~= "DRINK_LONG_BOTTLE" then
                    TPZInv.removeItemDurability(_source, index, itemData.Durability.Value, data.itemId, itemData.Durability.Remove)
                
                    SendNotification(_source, itemData.NotifyOnUse, "success")
                end
            end

        end)
    end
    
end)

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