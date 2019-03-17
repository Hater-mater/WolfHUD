if WolfgangHUD then
	WolfgangHUD.options_menu_data = {
		type = "menu",
		menu_id = "wolfganghud_options_menu",
		name_id = "wolfganghud_options_name",
		is_root = true,
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
			{	---- Menu Options ----
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
				name_id = "wolfganghud_remove_ad_box_title",
				value = {"MENU", "REMOVE_AD_BOX"},
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
			{
				type = "toggle",
				name_id = "wolfganghud_ready_on_num_enter_title",
				value = {"MENU", "READY_UP_ON_NUM_ENTER"},
				visible_reqs = {},
				enabled_reqs = {},
			},
			{	---- HUD Options ----
				type = "header",
				text_id = "wolfganghud_hud_options_name",
			},
			{
				type = "toggle",
				name_id = "wolfganghud_hide_in_camp_title",
				value = {"HUD", "SHOW_IN_CAMP"},
				visible_reqs = {},
				enabled_reqs = {},
				invert_value = true,
			},
			{	-- Player Panel
				type = "menu",
				menu_id = "wolfganghud_player_panel_options_menu",
				name_id = "wolfganghud_player_panel_options_name",
				visible_reqs = {},
				enabled_reqs = {},
				options = {
					{ -- KillCount
						type = "header",
						text_id = "wolfganghud_killcount_name",
					},
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
					{ -- Accuracy
						type = "header",
						text_id = "wolfganghud_accuracy_name",
					},
					{
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
					{ -- KillCount
						type = "header",
						text_id = "wolfganghud_killcount_name",
					},
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
					{ -- KillCount
						type = "header",
						text_id = "wolfganghud_killcount_name",
					},
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
			{	-- List panels
				type = "menu",
				menu_id = "wolfganghud_list_panels_options_menu",
				name_id = "wolfganghud_list_panels_options_name",
				visible_reqs = {},
				enabled_reqs = {},
				options = {
					{ -- Unit counters
						type = "header",
						text_id = "wolfganghud_unit_count_list_name",
					},
					{
						type = "toggle",
						name_id = "wolfganghud_use_hudlist_title",
						value = {"HUDList", "ENABLED"},
						visible_reqs = {},
						enabled_reqs = {},
					},
					{
						type = "multi_choice",
						name_id = "wolfganghud_hudlist_box_color_title",
						value = {"HUDList", "list_color"},
						visible_reqs = {},
						enabled_reqs = {
							{ setting = { "HUDList", "ENABLED" }, invert = false },
						},
						options = {},
						add_color_options = true,
						add_rainbow = false,
					},
					{
						type = "multi_choice",
						name_id = "wolfganghud_hudlist_box_bg_color_title",
						value = {"HUDList", "list_color_bg"},
						visible_reqs = {},
						enabled_reqs = {
							{ setting = { "HUDList", "ENABLED" }, invert = false },
						},
						options = {},
						add_color_options = true,
						add_rainbow = false,
					},
					{
						type = "divider",
					},
					{
						type = "slider",
						name_id = "wolfganghud_hudlist_scale_unit_count_title",
						value = {"HUDList", "unit_count_list_scale"},
						visible_reqs = {},
						enabled_reqs = {
							{ setting = { "HUDList", "ENABLED" }, invert = false },
						},
						min_value = 0.5,
						max_value = 2,
						decimal_places = 2,
					},
					{
						type = "slider",
						name_id = "wolfganghud_hudlist_progress_alpha_unit_count_title",
						value = {"HUDList", "unit_count_list_progress_alpha"},
						visible_reqs = {},
						enabled_reqs = {
							{ setting = { "HUDList", "ENABLED" }, invert = false },
						},
						min_value = 0.0,
						max_value = 1.0,
						decimal_places = 2,
					},
					{
						type = "divider",
					},
					{
						type = "toggle",
						name_id = "wolfganghud_hudlist_show_enemies_title",
						value = {"HUDList", "UNIT_COUNT_LIST", "show_enemies"},
						visible_reqs = {},
						enabled_reqs = {
							{ setting = { "HUDList", "ENABLED" }, invert = false },
						},
					},
					{
						type = "multi_choice",
						name_id = "wolfganghud_hudlist_enemycolor_title",
						value = {"HUDList", "enemy_color"},
						visible_reqs = {},
						enabled_reqs = {
							{ setting = { "HUDList", "ENABLED" }, invert = false },
							{ setting = { "HUDList", "UNIT_COUNT_LIST", "show_enemies" }, invert = false },
						},
						options = {},
						add_color_options = true,
						add_rainbow = false,
					},
					{
						type = "toggle",
						name_id = "wolfganghud_hudlist_seperate_specials_title",
						value = {"HUDList", "UNIT_COUNT_LIST", "aggregate_enemies"},
						visible_reqs = {},
						enabled_reqs = {
							{ setting = { "HUDList", "ENABLED" }, invert = false },
							{ setting = { "HUDList", "UNIT_COUNT_LIST", "show_enemies" }, invert = false },
						},
						invert_value = true,
					},
					{
						type = "multi_choice",
						name_id = "wolfganghud_hudlist_specialcolor_title",
						value = {"HUDList", "special_color"},
						visible_reqs = {},
						enabled_reqs = {
							{ setting = { "HUDList", "ENABLED" }, invert = false },
							{ setting = { "HUDList", "UNIT_COUNT_LIST", "show_enemies" }, invert = false },
							{ setting = { "HUDList", "UNIT_COUNT_LIST", "aggregate_enemies" }, invert = true },
						},
						options = {},
						add_color_options = true,
						add_rainbow = false,
					},
					{
						type = "divider",
					},
					{
						type = "toggle",
						name_id = "wolfganghud_hudlist_show_objectives_title",
						value = {"HUDList", "UNIT_COUNT_LIST", "show_objectives"},
						visible_reqs = {},
						enabled_reqs = {
							{ setting = { "HUDList", "ENABLED" }, invert = false },
						},
					},
					{
						type = "multi_choice",
						name_id = "wolfganghud_hudlist_objectivecolor_title",
						value = {"HUDList", "objective_color"},
						visible_reqs = {},
						enabled_reqs = {
							{ setting = { "HUDList", "ENABLED" }, invert = false },
							{ setting = { "HUDList", "UNIT_COUNT_LIST", "show_objectives" }, invert = false },
						},
						options = {},
						add_color_options = true,
						add_rainbow = false,
					},
				},
			},
			{	---- Gameplay ----
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
				name_id = "wolfganghud_auto_reload_title",
				value = {"GAMEPLAY", "AUTO_RELOAD"},
				visible_reqs = {},
				enabled_reqs = {},
			},
			{
				type = "toggle",
				name_id = "wolfganghud_auto_apply_weapon_skills_title",
				value = {"GAMEPLAY", "AUTO_APPLY_WEAPON_SKILLS"},
				visible_reqs = {},
				enabled_reqs = {},
			},
			{	---- Hosting ----
				type = "header",
				text_id = "wolfganghud_host_options_name",
			},
			{
				type = "toggle",
				name_id = "wolfganghud_kick_a_friend_title",
				value = {"HOST", "KICK_A_FRIEND"},
				visible_reqs = {},
				enabled_reqs = {},
			},
			{
				type = "toggle",
				name_id = "wolfganghud_instant_restart_title",
				value = {"HOST", "INSTANT_RESTART"},
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
		}
	}
end
