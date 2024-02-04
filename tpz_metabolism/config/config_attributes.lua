Attributes   = {}

Attributes.Animations = {

    ["EAT"] = {
		dict = "mech_inventory@eating@multi_bite@sphere_d8-2_sandwich",
		name = "quick_left_hand", 
		flag = 24
    },

	["EAT_BERRIES"] = {
		dict = "mech_pickup@plant@berries",
		name = "exit_eat", 
		flag = 0
    },


    ["DRINK"] = {
		dict = "amb_rest_drunk@world_human_drinking@male_a@idle_a",
		name = "idle_a", 
		flag = 24
	},

	["DRINK_ONCE"] = {
		dict = "mech_inventory@item@fallbacks@large_drink@left_handed",
		name = "use_quick_left_hand", 
		flag = 24
	},
  
}

Attributes.Vomits = {
	["vomit1"] = {
		dict = "amb_misc@world_human_vomit@male_a@idle_a",
		name = "idle_a" ,
		flag = 0,
	},

	["vomit2"] = {
		dict = "amb_misc@world_human_vomit@male_a@idle_c",
		name = "idle_g" ,
		flag = 0,
	},
	
	["vomit3"] = {
		dict = "amb_misc@world_human_vomit@male_a@idle_c",
		name = "idle_h" ,
		flag = 0,
	},    
}