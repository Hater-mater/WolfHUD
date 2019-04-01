if WolfgangHUD then
	WolfgangHUD.default_settings = {
		HUD = {
			SHOW_IN_CAMP						= false,
			PLAYER = {
				SHOW_ACCURACY					= true,
				KILLCOUNTER = {
					HIDE						= false,
					SHOW_SPECIAL_KILLS			= true,
					SHOW_HEADSHOT_KILLS			= true,
					COLOR						= "orange",
				},
			},
			PEER = {
				KILLCOUNTER = {
					HIDE						= false,
					SHOW_SPECIAL_KILLS			= true,
					SHOW_HEADSHOT_KILLS			= true,
					COLOR						= "orange",
				},
			},
			AI = {
				KILLCOUNTER = {
					HIDE						= false,
					SHOW_SPECIAL_KILLS			= true,
					SHOW_HEADSHOT_KILLS			= true,
					COLOR						= "orange",
				},
			},
			FHB = {
				ENABLED							= true,
				SIZE							= 20,
				MARGIN							= 2,
				ALPHA							= 0.7,
				COLOR_START						= "orange",
				COLOR_END						= "red",
				SHOW_FRIENDLY					= false,
				COLOR_FRIENDLY					= "green",
				PIE_COLOR_CUSTOM				= true,
				PIE_COLOR_START					= "light_gray",
				PIE_COLOR_END					= "gray",
			},
		},
		MENU = {
			STRAIGHT_TO_MAIN_MENU				= true,
			REMOVE_AD_BOX						= true,
			TRANSPARENT_PAUSE_MENU				= true,
			READY_UP_ON_NUM_ENTER				= true,
			NO_DEBRIEFING						= true,
		},
		HUDList = {
			ENABLED								= true,
			right_list_scale					= 1,
			right_list_progress_alpha			= 1,
			list_color							= "white",
			list_color_bg						= "black",
			enemy_color							= "orange",
			special_color						= "red",
			objective_color						= "yellow",
			RIGHT_LIST = {
				show_enemies					= true,
					aggregate_enemies			= false,
				show_objectives					= true,
			},
		},
		GAMEPLAY = {
			NO_SLOWMOTION						= true,
			AUTO_RELOAD							= true,
			--AUTO_APPLY_WEAPON_SKILLS			= true,
			REALISTIC_RELOAD					= false,
		},
		INTERACTION = {
			LOCK_MODE							= 3,
			MIN_TIMER_DURATION					= 0,
			EQUIPMENT_PRESS_INTERRUPT			= true,
			SHOW_LOCK_INDICATOR					= true,
			SHOW_BAR							= true,
			BAR_SCALE							= 1,
			TEXT_SCALE							= 1,
			SHOW_INTERRUPT_HINT					= true,
			SHOW_TIME_REMAINING					= true,
			GRADIENT_COLOR_START				= "orange",
			GRADIENT_COLOR						= "white",
			TIMER_SCALE							= 1,
			SHOW_RELOAD							= true,
			SHOW_MELEE							= true,
		},
		HOST = {
			INSTANT_RESTART						= true,
			KICK_A_FRIEND						= true,
		},
	}
	WolfgangHUD.settings = deep_clone(WolfgangHUD.default_settings)
end