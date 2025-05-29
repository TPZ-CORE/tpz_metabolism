Config = {}

Config = {
    
    DevMode       = false,
    Debug         = false,

    InitialValues = {
        Thirst  = 60, -- Max 100.
        Hunger  = 60, -- Max 100.
    },
    
    -- The following is a realistic sprinting stamina decrease system, if you don't like it, set it to false.
    RealisticSprintStaminaDescrease = true,

    -- Set it to false if you wan't the players to be able to run while drunk.
    DisablePlayerRunWhileDrunk = true,

    -- The value when a player reaches while drinking to consider as being drunk.
    AlcoholConsiderDrunk = 50,
    AlcoholConsiderVeryDrunk = 80,
    AlcoholRemoveByTime  = 3, -- Time in seconds.
    AlcoholRemoveByTimeValue = 1, -- The alcohol value to be removed based on @AlcoholRemoveByTime (MAX ALCOHOL == 100)

    HungerStripeValue    = 0, -- When hunger equals to the selected value, you start losing health.
    ThirstStripeValue    = 0, -- When thirst equals to the selected value, you start losing health.
    HealthDamageValue    = 5,

    -- This is the time rate which takes to execute the hunger and thirst drain 
    TimeRateRepeat       = 3, -- Time in seconds.

    HungerDrainIdle      = 0.03,  -- Hunger drop rate while standing.
    HungerDrainWalking   = 0.075, -- Hunger drop rate while walking.
    HungerDrainRunning   = 0.15, -- Hunger drop rate while running.

    ThirstDrainIdle      = 0.06,  -- Thirst drop rate while standing.
    ThirstDrainWalking   = 0.15, -- Thirst drop rate while walking.
    ThirstDrainRunning   = 0.3,   -- Thirst drop rate while running.

    MinTemperature       = -4, -- If the player temperature is that low, it will start doing damage to your health.
    MinTemperatureDamage = 2,  -- Set to false if you don't want to damage the player.
    MinTemperatureDrainThirst  = 0,  -- Set to 0 if you don't want to drain thirst when player's temperature reaches the selected value.

    MaxTemperature       = 40, -- If the player temperature is that high, it will start draining more water and hunger. (40°C As default)
    MaxTemperatureDrainThirst  = 0.3,  -- Set to 0 if you don't want to drain thirst when player's temperature reaches the selected value.

    -- Do not modify the hashes without knowledge.
    ClothingExtraTemperature = true,
    ClothingListHashes = {
        ['hat']               = {hash = 0x9925C067, temp = 1},
        ['gloves']            = {hash = 0xEABE0032, temp = 1},
        ['shirt']             = {hash = 0x2026C46D, temp = 2},
        ['pants']             = {hash = 0x1D4C528A, temp = 2},
        ['boots']             = {hash = 0x777EC6EF, temp = 2},
        ['vest']              = {hash = 0x485EE834, temp = 2},
        ['coats']             = {hash = 0xE06D30CE, temp = 3},
        ['closed_coats']      = {hash = 0x662AC34,  temp = 4},
        ['ponchos_1']         = {hash = 0xAF14310B, temp = 4},
        ['ponchos_2']         = {hash = 0x3C1A74CD, temp = 4},
    },

    DrinkCupAnimDuration = 60000, -- Determines how long the user will hold the coffee before throwing it away.
    DrinkBottleAnimDuration = 60000, -- Determines how long the user will hold a bottle before throwing it away.
    EatBowlAnimDuration  = 60000, -- Determines how long the user will hold the bowl or plate before throwing it away.

    Notifications = {

        -- If the player is feeling hungry, thirsty or stressed, it will display him a message very X minutes as a warning.
        NotificationWarningDelay = 2,

        Hunger = {
            Enabled     = true,
            Value       = 20,

            NotifyTitle = "~t3~Hunger",
            Notify      = "You start feeling hungry, eat something..",
            Cooldown    = 5000, -- The time in milliseconds.
        },

        Thirst = {
            Enabled     = true,
            Value       = 20,

            NotifyTitle = "~t3~Thirst",
            Notify      = "You start feeling thirsty and dry, drink something..",
            Cooldown    = 5000, -- The time in milliseconds.
        },

        Stress = {
            Enabled     = true,
            Value       = 90,

            NotifyTitle = "~t3~Stress",
            Notify      = "You have to calm down, you start feeling very stressed..",
            Cooldown    = 5000, -- The time in milliseconds.
        },

        -- Temperature Notification Values are equal to the configuration options above (MinTemperature & MaxTemperature).
        Temperature = {
        
            Cold = { Enabled = true, NotifyTitle = "~t3~Temperature", Notify = "You are feeling very cold, you should cover yourself more before something happens.", Cooldown = 10000 },
            Hot  = { Enabled = true, NotifyTitle = "~t3~Temperature", Notify = "You are feeling very warm, you should wear off some clothes.", Cooldown = 10000 },
        },

    },

}


-----------------------------------------------------------
--[[ Notification Functions  ]]--
-----------------------------------------------------------

-- @param source is always null when called from client.
-- @param messageType returns "success" or "error" depends when and where the message is sent.
function SendNotification(source, message, messageType)

    if not source then
        TriggerEvent('tpz_core:sendRightTipNotification', message, 3000)
    else
        TriggerClientEvent('tpz_core:sendRightTipNotification', source, message, 3000)
    end
  
end
