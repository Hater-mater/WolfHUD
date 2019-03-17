if WolfgangHUD then
	local default_lang = "english"
	for _, filename in pairs(file.GetFiles(WolfgangHUD.mod_path .. "loc/")) do
		local str = filename:match('^(.*).json$')
		if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
			default_lang = str
			break
		end
	end
	WolfgangHUD.default_settings = {
		LANGUAGE								= default_lang,
		MENU ={
			STRAIGHT_TO_MAIN_MENU				= true,
			REMOVE_AD_BOX						= true,
			TRANSPARENT_PAUSE_MENU				= true,
			READY_UP_ON_NUM_ENTER				= true,
		},
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
		},
		HUDList = {
			ENABLED								= true,
			unit_count_list_scale				= 1,
			unit_count_list_progress_alpha		= 1,
			list_color							= "white",
			list_color_bg						= "black",
			enemy_color							= "orange",
			special_color						= "red",
			objective_color						= "yellow",
			UNIT_COUNT_LIST = {
				show_enemies					= true,
					aggregate_enemies			= false,
				show_objectives					= true,
			},
		},
		GAMEPLAY = {
			NO_SLOWMOTION						= true,
			AUTO_RELOAD							= true,
			--AUTO_APPLY_WEAPON_SKILLS			= true,
		},
		HOST = {
			INSTANT_RESTART						= true,
			KICK_A_FRIEND						= true,
		},
	}
	WolfgangHUD.settings = deep_clone(WolfgangHUD.default_settings)
end