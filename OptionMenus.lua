if WolfgangHUD then
	WolfgangHUD.options_menu_data = {
		type = "menu",
		menu_id = "wolfganghud_options_menu",
		name_id = "wolfganghud_options_name",
		options = {
			{
				type = "multi_choice",
				name_id = "wolfganghud_language_title",
				options = {
					["english"] = "wolfganghud_languages_english",
					["german"] = "wolfganghud_languages_german",
					["dutch"] = "wolfganghud_languages_dutch",
					["french"] = "wolfganghud_languages_french",
					["italian"] = "wolfganghud_languages_italian",
					["spanish"] = "wolfganghud_languages_spanish",
					["portuguese"] = "wolfganghud_languages_portuguese",
					["russian"] = "wolfganghud_languages_russian",
					["chinese"] = "wolfganghud_languages_chinese",
					["korean"] = "wolfganghud_languages_korean"
				},
				visible_reqs = {},
				enabled_reqs = {},
				value = {"LANGUAGE"},
			},
			{	-- Menu Options
				type = "header",
				text_id = "wolfganghud_menu_options_name",
			},
			{
				type = "toggle",
				name_id = "wolfganghud_straight_to_main_menu_title",
				value = {"MENU", "STRAIGHT_TO_MAIN_MENU"},
				visible_reqs = {},
				enabled_reqs = {},
			},
			{
				type = "toggle",
				name_id = "wolfganghud_transparent_pause_menu_title",
				value = {"MENU", "TRANSPARENT_PAUSE_MENU"},
				visible_reqs = {},
				enabled_reqs = {},
			},
			{	-- HUD Options
				type = "header",
				text_id = "wolfganghud_hud_options_name",
			},
			{	-- Player Panel
				type = "menu",
				menu_id = "wolfganghud_player_panel_options_menu",
				name_id = "wolfganghud_player_panel_options_name",
				visible_reqs = {},
				enabled_reqs = {},
				options = {
					{
						type = "toggle",
						name_id = "wolfganghud_show_killcount_title",
						visible_reqs = {},
						enabled_reqs = {},
						value = {"HUD", "PLAYER", "KILLCOUNTER", "HIDE"},
						invert_value = true,
					},
					{
						type = "toggle",
						name_id = "wolfganghud_show_special_title",
						visible_reqs = {},
						enabled_reqs = {
							{ setting = {"HUD", "PLAYER", "KILLCOUNTER", "HIDE"}, invert = true }
						},
						value = {"HUD", "PLAYER", "KILLCOUNTER", "SHOW_SPECIAL_KILLS"},
					},
					{
						type = "toggle",
						name_id = "wolfganghud_show_head_title",
						visible_reqs = {},
						enabled_reqs = {
							{ setting = {"HUD", "PLAYER", "KILLCOUNTER", "HIDE"}, invert = true }
						},
						value = {"HUD", "PLAYER", "KILLCOUNTER", "SHOW_HEADSHOT_KILLS"},
					},
					{
						type = "multi_choice",
						name_id = "wolfganghud_killcount_color_title",
						value = {"HUD", "PLAYER", "KILLCOUNTER", "COLOR"},
						visible_reqs = {},
						enabled_reqs = {
							{ setting = {"HUD", "PLAYER", "KILLCOUNTER", "HIDE"}, invert = true }
						},
						options = {},
						add_color_options = true,
						add_rainbow = false,
					},
					{
						type = "divider",
					},
					{ -- Accuracy
						type = "toggle",
						name_id = "wolfganghud_player_show_accuracy_title",
						visible_reqs = {},
						enabled_reqs = {},
						value = {"HUD", "PLAYER", "SHOW_ACCURACY"},
					},
				},
			},
			{	-- Teammate Panels
				type = "menu",
				menu_id = "wolfganghud_peer_panels_options_menu",
				name_id = "wolfganghud_peer_panels_options_name",
				visible_reqs = {},
				enabled_reqs = {},
				options = {
					{
						type = "toggle",
						name_id = "wolfganghud_show_killcount_title",
						visible_reqs = {},
						enabled_reqs = {},
						value = {"HUD", "PEER", "KILLCOUNTER", "HIDE"},
						invert_value = true,
					},
					{
						type = "toggle",
						name_id = "wolfganghud_show_special_title",
						visible_reqs = {},
						enabled_reqs = {
							{ setting = {"HUD", "PEER", "KILLCOUNTER", "HIDE"}, invert = true }
						},
						value = {"HUD", "PEER", "KILLCOUNTER", "SHOW_SPECIAL_KILLS"},
					},
					{
						type = "toggle",
						name_id = "wolfganghud_show_head_title",
						visible_reqs = {},
						enabled_reqs = {
							{ setting = {"HUD", "PEER", "KILLCOUNTER", "HIDE"}, invert = true }
						},
						value = {"HUD", "PEER", "KILLCOUNTER", "SHOW_HEADSHOT_KILLS"},
					},
					{
						type = "multi_choice",
						name_id = "wolfganghud_killcount_color_title",
						value = {"HUD", "PEER", "KILLCOUNTER", "COLOR"},
						visible_reqs = {},
						enabled_reqs = {
							{ setting = {"HUD", "PEER", "KILLCOUNTER", "HIDE"}, invert = true }
						},
						options = {},
						add_color_options = true,
						add_rainbow = false,
					},
				},
			},
			{	-- Bot Panels
				type = "menu",
				menu_id = "wolfganghud_ai_panels_options_menu",
				name_id = "wolfganghud_ai_panels_options_name",
				visible_reqs = {},
				enabled_reqs = {},
				options = {
					{
						type = "toggle",
						name_id = "wolfganghud_show_killcount_title",
						visible_reqs = {},
						enabled_reqs = {},
						value = {"HUD", "AI", "KILLCOUNTER", "HIDE"},
						invert_value = true,
					},
					{
						type = "toggle",
						name_id = "wolfganghud_show_special_title",
						visible_reqs = {},
						enabled_reqs = {
							{ setting = {"HUD", "AI", "KILLCOUNTER", "HIDE"}, invert = true }
						},
						value = {"HUD", "AI", "KILLCOUNTER", "SHOW_SPECIAL_KILLS"},
					},
					{
						type = "toggle",
						name_id = "wolfganghud_show_head_title",
						visible_reqs = {},
						enabled_reqs = {
							{ setting = {"HUD", "AI", "KILLCOUNTER", "HIDE"}, invert = true }
						},
						value = {"HUD", "AI", "KILLCOUNTER", "SHOW_HEADSHOT_KILLS"},
					},
					{
						type = "multi_choice",
						name_id = "wolfganghud_killcount_color_title",
						value = {"HUD", "AI", "KILLCOUNTER", "COLOR"},
						visible_reqs = {},
						enabled_reqs = {
							{ setting = {"HUD", "AI", "KILLCOUNTER", "HIDE"}, invert = true }
						},
						options = {},
						add_color_options = true,
						add_rainbow = false,
					},
				},
			},
			{	-- Gameplay
				type = "header",
				text_id = "wolfganghud_gameplay_options_name",
			},
			{
				type = "toggle",
				name_id = "wolfganghud_no_slowmotion_title",
				value = {"GAMEPLAY", "NO_SLOWMOTION"},
				visible_reqs = {},
				enabled_reqs = {},
			},
			{
				type = "toggle",
				name_id = "wolfganghud_no_bot_bullet_coll_title",
				value = {"GAMEPLAY", "NO_BOT_BULLET_COLL"},
				visible_reqs = {},
				enabled_reqs = {},
			},
			{
				type = "toggle",
				name_id = "wolfganghud_auto_reload_title",
				value = {"GAMEPLAY", "AUTO_RELOAD"},
				visible_reqs = {},
				enabled_reqs = {},
			},
			{	-- Restart
				type = "header",
				text_id = "wolfganghud_restart_options_name",
			},
			{
				type = "toggle",
				name_id = "wolfganghud_instant_restart_title",
				value = {"RESTART", "INSTANT_RESTART"},
				visible_reqs = {},
				enabled_reqs = {},
			},
			{
				type = "keybind",
				name_id = "wolfganghud_restart_hotkey_title",
				keybind_id = "wolfganghud_restart_hotkey",
				visible_reqs = {},
				enabled_reqs = {},
			},
			{	-- Reset
				type = "header",
				text_id = "wolfganghud_reset_options_title",
			},
			{
				type = "button",
				name_id = "wolfganghud_reset_options_title",
				clbk = "Reset",
			},
		}
	}
end
