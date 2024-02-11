local TPZ     = {}

TriggerEvent("getTPZCore", function(cb) TPZ = cb end)

-----------------------------------------------------------
--[[ Functions  ]]--
-----------------------------------------------------------

local function Round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

-----------------------------------------------------------
--[[ Base Events  ]]--
-----------------------------------------------------------

-- @playerDropped is triggered when player left the game in order to save
-- the character metabolism (if regitered) properly in the database.
AddEventHandler('playerDropped', function (reason)
    local _source = source

    if ConnectedPlayers[_source] == nil then
        return
    end

    local playerData       = ConnectedPlayers[_source]

    local meta             = { hunger = Round(playerData.hunger, 4), thirst = Round(playerData.thirst, 4), stress = Round(playerData.stress, 4), alcohol = Round(playerData.alcohol, 4) }
    local UpdateParameters = { ['charidentifier'] = playerData.charidentifier , ['meta'] = json.encode(meta)}

    exports.ghmattimysql:execute("UPDATE `characters` SET `meta` = @meta WHERE `charidentifier` = @charidentifier", UpdateParameters)

    ConnectedPlayers[_source] = nil
end)


-----------------------------------------------------------
--[[ General Events  ]]--
-----------------------------------------------------------

RegisterServerEvent("tpz_metabolism:requestPlayerMetabolism")
AddEventHandler("tpz_metabolism:requestPlayerMetabolism", function()
    local _source = source

    local xPlayer = TPZ.GetPlayer(_source)

    if xPlayer == nil or not xPlayer.loaded() then
        return
    end

    local identifier      = xPlayer.getIdentifier()
    local charidentifier  = xPlayer.getCharacterIdentifier()
    local playerName      = GetPlayerName(_source)
    
    local Parameters      = { ['charidentifier'] = charidentifier }

    exports.ghmattimysql:execute('SELECT * FROM characters WHERE charidentifier = @charidentifier', Parameters, function(result)
        
        local meta = json.decode(result[1].meta)

        if meta.hunger == nil then meta.hunger = Config.InitialValues.Hunger end
        if meta.thirst == nil then meta.thirst = Config.InitialValues.Thirst end
        if meta.stress == nil then meta.stress = 0 end
        if meta.alcohol == nil then meta.alcohol = 0 end

        -- We are registering the connected player with its metabolism data to be used and updated properly.
        RegisterConnectedPlayer(_source, identifier, charidentifier, {hunger = meta.hunger, thirst = meta.thirst, stress = meta.stress, alcohol = meta.alcohol })

        TriggerClientEvent("tpz_metabolism:registerPlayerMetabolism", _source, meta.hunger, meta.thirst, meta.stress, meta.alcohol)

        if Config.Debug then
            print("[TPZ-CORE Metabolism] Successfully loaded user " .. identifier .. " (" .. playerName .. ")")
        end

    end)

end)

RegisterServerEvent("tpz_metabolism:updateMetabolismType")
AddEventHandler("tpz_metabolism:updateMetabolismType", function(type, value)
    local _source = source

    if GetPlayerName(_source) == nil or ConnectedPlayers[_source] == nil then
        return
    end

    if type == "HUNGER" then 
        ConnectedPlayers[_source].hunger = value

    elseif type == "THIRST" then
        ConnectedPlayers[_source].thirst = value

    elseif type == "STRESS" then
        ConnectedPlayers[_source].stress = value

    elseif type == "ALCOHOL" then
        ConnectedPlayers[_source].alcohol = value
    end

end)
