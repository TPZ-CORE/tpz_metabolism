Items = {}

Items = {

	
	PromptKeys     = {
		['USE']       = { key = 0xF84FA74F,    label = "Drink",    hold = 250 },
		['CANCEL']    = { key = 0x4AF4D473,    label = "Cancel", hold = 1000 },
	},


	--------------------------------------------------------------------------------------------------------------
	-- (!) IMPORTANT NOTES.
	--------------------------------------------------------------------------------------------------------------

	-- For every item, make sure in the database, the action exists, otherwise, the item won't be able to be used.
	-- For food, the set the action to `eatable` and for consumable, set the action to `drinkable`.

	-- Food should not be stackables so they can expire and be removed by time.

	-- If a consumable is not stackable and has durability, you can remove durability on every use (for example,
    -- a containers with alcohol to last longer).

	-- For food, i suggest to not add Durability Remove, the durability exists as i pointed above for the
	-- food expiration and only.

	-- Action Animation Types:

	-- 1. 'EAT'
	-- 2. 'EAT_BOWL_OR_PLATE'
	-- 3. 'EAT_BERRIES'
	-- 4. 'DRINK_ONCE'
	-- 5. 'DRINK_MUG'

	--------------------------------------------------------------------------------------------------------------

	RegisteredUsableItems = {
		
		['consumable_peach'] = {

			Label  = "Peach",
			Action = { Animation = "EAT", Object = "s_peach01x" },

			CloseInventory = true,
			RemoveOnUse    = true,

			-- Would you like to give an item when using the specified item? 
			GiveItemOnUse  = { Enabled = false, Item = "" },

			-- The following option is only for non-stackable items.
			-- If Durability Enabled is true, set RemoveOnUse option above to false, otherwise the following feature,
			-- will be pointless.
			Durability = {
				Enabled = false,
				Value  = 0,
				Remove = true, -- If durability hits "0", remove the item?
			},

			Metabolism = {
				Hunger = { Type = "add", Value = 10 },
				Thirst = { Type = "remove", Value = 5  },

				-- Stress Types : "add", "remove" (Keep in mind, "add", adds more stress to the player, not actual removing).
				Stress = { Type = "add", Value = 0 },

				InnerCoreStamina = 0,
				InnerCoreStaminaGold = 0.0,
				OuterCoreStaminaGold = 0.0,

				InnerCoreHealth = 0,
				InnerCoreHealthGold = 0.0,
				OuterCoreHealthGold = 0.0,
			},

			Alcohol = {
				Enabled = false,
				Value = 0, -- The value to add for a player to become drunk (MAX VALUE IS 100%).
			},

			Temperature = { Enabled = false },

			NotifyOnUse = "You just ate a Peach.", -- Set to false if you don't want to send any notification on use.
		},
		
		['consumable_bread'] = {

			Label  = "Bread",
			Action = { Animation = "EAT", Object = "p_bread06x" },

			CloseInventory = true,
			RemoveOnUse    = true,

			-- Would you like to give an item when using the specified item? 
			GiveItemOnUse  = { Enabled = false, Item = "" },

			-- The following option is only for non-stackable items.
			-- If Durability Enabled is true, set RemoveOnUse option above to false, otherwise the following feature,
			-- will be pointless.
			Durability = {
				Enabled = false,
				Value  = 0,
				Remove = true, -- If durability hits "0", remove the item?
			},

			Metabolism = {
				Hunger = { Type = "add", Value = 15 },
				Thirst = { Type = "add", Value = 0  },

				-- Stress Types : "add", "remove" (Keep in mind, "add", adds more stress to the player, not actual removing).
				Stress = { Type = "add", Value = 0 },

				InnerCoreStamina = 0,
				InnerCoreStaminaGold = 0.0,
				OuterCoreStaminaGold = 0.0,

				InnerCoreHealth = 0,
				InnerCoreHealthGold = 0.0,
				OuterCoreHealthGold = 0.0,
			},

			Alcohol = {
				Enabled = false,
				Value = 0, -- The value to add for a player to become drunk (MAX VALUE IS 100%).
			},

			Temperature = { Enabled = false },

			NotifyOnUse = "You just ate a piece of Bread.", -- Set to false if you don't want to send any notification on use.
		},

	
		['consumable_coffee'] = {

			Label  = "Coffee Mug",
			Action = { Animation = "DRINK_MUG", Object = "p_mugcoffee01x" },

			CloseInventory = true,
			RemoveOnUse    = true,

			-- Would you like to give an item when using the specified item? 
			GiveItemOnUse  = { Enabled = false, Item = "" },

			-- The following option is only for non-stackable items.
			-- If Durability Enabled is true, set RemoveOnUse option above to false, otherwise the following feature,
			-- will be pointless.
			Durability = {
				Enabled = false,
				Value  = 0,
				Remove = true, -- If durability hits "0", remove the item?
			},

			Metabolism = {
				Hunger = { Type = "add", Value = 0 },
				Thirst = { Type = "add", Value = 5 },

				-- Stress Types : "add", "remove" (Keep in mind, "add", adds more stress to the player, not actual removing).
				Stress = { Type = "remove", Value = 5 },

				InnerCoreStamina = 0,
				InnerCoreStaminaGold = 0.0,
				OuterCoreStaminaGold = 0.0,

				InnerCoreHealth = 0,
				InnerCoreHealthGold = 0.0,
				OuterCoreHealthGold = 0.0,
			},

			Alcohol = {
				Enabled = false,
				Value = 0, -- The value to add for a player to become drunk (MAX VALUE IS 100%).
			},

			-- Temperature Types : "add", "remove", 
			-- Value is the Temperature Value to add or remove and the Duration to how long will the extra temperature change will last.
			Temperature = { Enabled = true, Type = "add", Value = 5, Duration = 3},

			NotifyOnUse = false, -- Set to false if you don't want to send any notification on use.
		},
	
		['consumable_water_bottle'] = {

			Label  = "Water Bottle",
			Action = { Animation = "DRINK_ONCE", Object = "s_rc_poisonedwater01x" },

			CloseInventory = true,
			RemoveOnUse    = true,

			-- Would you like to give an item when using the specified item? 
			GiveItemOnUse  = { Enabled = true, Item = "empty_bottle" },

			-- The following option is only for non-stackable items.
			-- If Durability Enabled is true, set RemoveOnUse option above to false, otherwise the following feature,
			-- will be pointless.
			Durability = {
				Enabled = false,
				Value  = 0,
				Remove = false, -- If durability hits "0", remove the item?
			},

			Metabolism = {
				Hunger = { Type = "add", Value = 0  },
				Thirst = { Type = "add", Value = 25 },

				-- Stress Types : "add", "remove" (Keep in mind, "add", adds more stress to the player, not actual removing).
				Stress = { Type = "remove", Value = 0 },

				InnerCoreStamina = 0,
				InnerCoreStaminaGold = 0.0,
				OuterCoreStaminaGold = 0.0,

				InnerCoreHealth = 0,
				InnerCoreHealthGold = 0.0,
				OuterCoreHealthGold = 0.0,
			},

			Alcohol = {
				Enabled = false,
				Value = 0, -- The value to add for a player to become drunk (MAX VALUE IS 100%).
			},

			-- Temperature Types : "add", "remove", 
			-- Value is the Temperature Value to add or remove and the Duration to how long will the extra temperature change will last.
			Temperature = { Enabled = false },

			NotifyOnUse = "Drinking some water..", -- Set to false if you don't want to send any notification on use.
		},

		['consumable_tequila'] = {

			Label  = "Tequila Bottle",
			Action = { Animation = "DRINK_LONG_BOTTLE", Object = "p_gen_bottletequila01x" },

			-- (!) REQUIRED FOR DRINK_LONG_BOTTLE TO ATTACH THE BOTTLE IN THE PLAYERS HAND PROPERLY.
			ObjectAttachment = { Attachment = "skel_r_hand", x = 0.10, y = -0.07, z = -0.14, xRot = -47.0, yRot = -3.0, zRot = 0},  

			CloseInventory = true,
			RemoveOnUse    = false,

			-- Would you like to give an item when using the specified item? 
			GiveItemOnUse  = { Enabled = false, Item = "" },

			-- The following option is only for non-stackable items.
			-- If Durability Enabled is true, set RemoveOnUse option above to false, otherwise the following feature,
			-- will be pointless.
			Durability = {
				Enabled = true,
				Value   = 10,  -- The value is removed on every use (drinking sip) due to `DRINK_LONG_BOTTLE`.
				Remove  = true, -- If durability hits "0", remove the item?
			},

			Metabolism = {
				Hunger = { Type = "add", Value = 0 },  -- The value is added on every use (drinking sip) due to `DRINK_LONG_BOTTLE`.
				Thirst = { Type = "add", Value = 4 }, -- The value is added on every use (drinking sip) due to `DRINK_LONG_BOTTLE`.

				-- Stress Types : "add", "remove" (Keep in mind, "add", adds more stress to the player, not actual removing).
				Stress = { Type = "remove", Value = 5 }, -- The value is added on every use (drinking sip) due to `DRINK_LONG_BOTTLE`.

				InnerCoreStamina = 0,
				InnerCoreStaminaGold = 0.0,
				OuterCoreStaminaGold = 0.0,
 
				InnerCoreHealth = 0,
				InnerCoreHealthGold = 0.0,
				OuterCoreHealthGold = 0.0,
			},

			Alcohol = {
				Enabled = true,

				-- The value to add for a player to become drunk (MAX VALUE IS 100%).
				-- The value is added on every use (drinking sip).
				Value = 15,
			},

			-- Temperature Types : "add", "remove", 
			-- Value is the Temperature Value to add or remove and the Duration to how long will the extra temperature change will last.
			Temperature = { Enabled = true, Type = "add", Value = 7, Duration = 5 },

			NotifyOnUse = "Drinking some tequila..", -- Set to false if you don't want to send any notification on use.
		},
	
	}
}
