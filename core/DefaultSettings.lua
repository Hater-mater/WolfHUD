if WolfgangHUD then
	WolfgangHUD.default_settings = {
		HUD = {
			LAYOUT								= 1,
			SHOW_IN_CAMP						= false,
			COLORIZE_NAMES						= true,
			LEVELS_BEFORE_NAME					= true,
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
					COLOR						= "white",
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
			DamagePopup = {
				DISPLAY_MODE					= 3,
				DURATION						= 2,
				SCALE							= 0.6,
				SKULL_SCALE						= 0.9,
				SKULL_ALIGN						= 2,
				HEIGHT							= 30,
				ALPHA							= 0.8,
				COLOR							= "yellow",
				HEADSHOT_COLOR					= "red",
				CRITICAL_COLOR					= "light_purple",
				CUSTOM_AI_COLOR_USE				= true,
				CUSTOM_AI_COLOR					= "white",
			},
			Suspicion = {
				SCALE							= 1.0,
				SHOW_PD2HUD						= true,
				SHOW_PERCENTAGE_NUMERIC			= true,
				COLOR_START						= "light_blue",
				COLOR_END						= "red",
				SHOW_DETECTED_TEXT				= false,
			},
		},
		MENU = {
			STRAIGHT_TO_MAIN_MENU				= false,
			STREAMLINE							= true,
			ADD_JOIN_MENU						= true,
			ADD_JOIN_MENU_OFFLINE				= true,
			REMOVE_AD_BOX						= true,
			TRANSPARENT_PAUSE_MENU				= false,
			READY_UP_ON_NUM_ENTER				= true,
			NO_DEBRIEFING						= false,
			MARK_STEALTHABLES					= true,
			SHOW_HIDDEN_WEAPON_STATS			= true,
			SHOW_DETECTION_RISK					= true,
		},
		HUDList = {
			ENABLED								= true,
			right_list_scale					= 1.2,
			right_list_progress_alpha			= 1,
			list_color							= "white",
			list_color_bg						= "black",
			enemy_color							= "orange",
			special_color						= "red",
			objective_color						= "yellow",
			valuable_color						= "orange",
			mission_pickup_color				= "white",
			combat_pickup_color					= "light_gray",
			flare_color							= "red",
			use_dogtag_values					= true,
			RIGHT_LIST = {
				show_enemies					= true,
					aggregate_enemies			= false,
				show_objectives					= true,
				show_loot						= true,
				SHOW_PICKUP_CATEGORIES = {
					valuables					= true,
					mission_pickups				= true,
					combat_pickups				= false,
					flares						= true,
				},
			},
		},
		CustomWaypoints = {
			SHOW_PICKUPS						= true,
			LOOT = {
				SHOW							= true,
				ICON							= true,
				OFFSET							= 15,
				ANGLE							= 20,
			},
		},
		GAMEPLAY = {
			FOV_BASED_SENSIVITY					= true,
			NO_SLOWMOTION						= true,
			AUTO_RELOAD							= true,
			AUTO_RELOAD_SINGLE					= true,
			--AUTO_APPLY_WEAPON_SKILLS			= true,
			REALISTIC_RELOAD					= false,
		},
		GAME_SETTINGS = {
			DIFFICULTY							= 2,		-- Global.game_settings.difficulty [1-4] easy, normal, hard, very hard
			PERMISSION							= 1,		-- Global.game_settings.permission [1-3] public, friends_only, private
			DROP_IN_ALLOWED						= true,		-- Global.game_settings.drop_in_allowed
			TEAM_AI								= true,		-- Global.game_settings.team_ai
			MAX_TEAM_AI							= 3,		-- custom [1-3]
			--AUTO_KICK							= true,		-- Global.game_settings.auto_kick TODO?
		},
		INTERACTION = {
			LOCK_MODE							= 3,
			MIN_TIMER_DURATION					= 0,
			EQUIPMENT_PRESS_INTERRUPT			= true,
			SHOW_LOCK_INDICATOR					= false,
			SHOW_BAR							= false,
			BAR_SCALE							= 1,
			TEXT_SCALE							= 1,
			SHOW_INTERRUPT_HINT					= true,
			SHOW_TIME_REMAINING					= true,
			GRADIENT_COLOR_START				= "orange",
			GRADIENT_COLOR						= "white",
			TIMER_SCALE							= 1.2,
			TIMER_OFFSET_X						= 0,
			TIMER_OFFSET_Y						= 36,
			HIDE_MOTION_DOT						= false,
			SHOW_RELOAD							= true,
			SHOW_MELEE							= true,
		},
		HOST = {
			INSTANT_RESTART						= true,
			KICK_A_FRIEND						= true,
		},
		SOUND = {
			MUTE_TOASTS							= false,
		},
	}
	WolfgangHUD.settings = deep_clone(WolfgangHUD.default_settings)
end