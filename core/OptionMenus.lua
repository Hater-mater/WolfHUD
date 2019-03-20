if WolfgangHUD then
	WolfgangHUD.options_menu_data = {
		type = "menu",
		menu_id = "wolfganghud_options_menu",
		name_id = "wolfganghud_options_name",
		is_root = true,
		options = {
			{	-- HUD Options
				type = "menu",
				menu_id = "wolfganghud_hud_options_name",
				name_id = "wolfganghud_hud_options_name",
				visible_reqs = {},
				enabled_reqs = {},
				options = {
					{ -- General
						y_offset = 320,
						type = "header",
						text_id = "wolfganghud_hud_general_name",
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
								y_offset = 320,
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
								y_offset = 320,
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
								y_offset = 320,
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
						},
					},
					{	-- List panels
						type = "menu",
						menu_id = "wolfganghud_hudlist_options_menu",
						name_id = "wolfganghud_hudlist_options_name",
						visible_reqs = {},
						enabled_reqs = {},
						options = {
							{ -- General
								y_offset = 320,
								type = "header",
								text_id = "wolfganghud_hudlist_general_name",
							},
							{
								type = "toggle",
								name_id = "wolfganghud_hudlist_show_title",
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
								y_offset = 100, -- shift for next header
							},
							{ -- Unit Types
								y_offset = 320,
								type = "header",
								text_id = "wolfganghud_hudlist_unit_types_name",
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
					{	-- Floating Health Bars
						type = "menu",
						menu_id = "wolfganghud_fhb_options_menu",
						name_id = "wolfganghud_fhb_options_name",
						visible_reqs = {},
						enabled_reqs = {},
						options = {
							{ -- General
								y_offset = 320,
								type = "header",
								text_id = "wolfganghud_fhb_general_name",
							},
							{
								type = "toggle",
								name_id = "wolfganghud_use_fhb_title",
								value = {"HUD", "FHB", "ENABLED"},
								visible_reqs = {},
								enabled_reqs = {},
							},
							{
								type = "slider",
								name_id = "wolfganghud_fhb_size_title",
								value = {"HUD", "FHB", "SIZE"},
								visible_reqs = {},
								enabled_reqs = {
									{ setting = { "HUD", "FHB", "ENABLED" }, invert = false },
								},
								min_value = 10,
								max_value = 100,
								decimal_places = 0,
							},
							{
								type = "slider",
								name_id = "wolfganghud_fhb_margin_title",
								value = {"HUD", "FHB", "MARGIN"},
								visible_reqs = {},
								enabled_reqs = {
									{ setting = { "HUD", "FHB", "ENABLED" }, invert = false },
								},
								min_value = 0,
								max_value = 20,
								decimal_places = 0,
							},
							{
								type = "slider",
								name_id = "wolfganghud_fhb_alpha_title",
								value = {"HUD", "FHB", "ALPHA"},
								visible_reqs = {},
								enabled_reqs = {
									{ setting = { "HUD", "FHB", "ENABLED" }, invert = false },
								},
								min_value = 0,
								max_value = 1,
								decimal_places = 2,
							},
							{ -- Pie Color
								type = "header",
								text_id = "wolfganghud_fhb_pie_name",
							},
							{
								type = "toggle",
								name_id = "wolfganghud_fhb_custom_pie_color_title",
								value = {"HUD", "FHB", "PIE_COLOR_CUSTOM"},
								visible_reqs = {},
								enabled_reqs = {
									{ setting = { "HUD", "FHB", "ENABLED" }, invert = false },
								},
							},
							{
								type = "multi_choice",
								name_id = "wolfganghud_fhb_pie_color_start_title",
								value = {"HUD", "FHB", "PIE_COLOR_START"},
								visible_reqs = {},
								enabled_reqs = {
									{ setting = { "HUD", "FHB", "ENABLED" }, invert = false },
									{ setting = { "HUD", "FHB", "PIE_COLOR_CUSTOM" }, invert = false },
								},
								options = {},
								add_color_options = true,
								add_rainbow = false,
							},
							{
								type = "multi_choice",
								name_id = "wolfganghud_fhb_pie_color_end_title",
								value = {"HUD", "FHB", "PIE_COLOR_END"},
								visible_reqs = {},
								enabled_reqs = {
									{ setting = { "HUD", "FHB", "ENABLED" }, invert = false },
									{ setting = { "HUD", "FHB", "PIE_COLOR_CUSTOM" }, invert = false },
								},
								options = {},
								add_color_options = true,
								add_rainbow = false,
							},
							{ -- Enemies
								y_offset = 320,
								type = "header",
								text_id = "wolfganghud_fhb_enemy_name",
							},
							{
								type = "multi_choice",
								name_id = "wolfganghud_fhb_color_start_title",
								value = {"HUD", "FHB", "COLOR_START"},
								visible_reqs = {},
								enabled_reqs = {
									{ setting = { "HUD", "FHB", "ENABLED" }, invert = false },
								},
								options = {},
								add_color_options = true,
								add_rainbow = false,
							},
							{
								type = "multi_choice",
								name_id = "wolfganghud_fhb_color_end_title",
								value = {"HUD", "FHB", "COLOR_END"},
								visible_reqs = {},
								enabled_reqs = {
									{ setting = { "HUD", "FHB", "ENABLED" }, invert = false },
								},
								options = {},
								add_color_options = true,
								add_rainbow = false,
							},
							{ -- Friendlies
								type = "header",
								text_id = "wolfganghud_fhb_friendly_name",
							},
							{
								type = "toggle",
								name_id = "wolfganghud_fhb_show_friendly_title",
								value = {"HUD", "FHB", "SHOW_FRIENDLY"},
								visible_reqs = {},
								enabled_reqs = {
									{ setting = { "HUD", "FHB", "ENABLED" }, invert = false },
								},
							},
							{
								type = "multi_choice",
								name_id = "wolfganghud_fhb_color_friendly_title",
								value = {"HUD", "FHB", "COLOR_FRIENDLY"},
								visible_reqs = {},
								enabled_reqs = {
									{ setting = { "HUD", "FHB", "ENABLED" }, invert = false },
									{ setting = { "HUD", "FHB", "SHOW_FRIENDLY" }, invert = false },
								},
								options = {},
								add_color_options = true,
								add_rainbow = false,
							},
						},
					},
				},
			},
			{	-- Menu Options
				type = "menu",
				menu_id = "wolfganghud_menu_options_name",
				name_id = "wolfganghud_menu_options_name",
				visible_reqs = {},
				enabled_reqs = {},
				options = {
					{ -- Main Menu
						y_offset = 320,
						type = "header",
						text_id = "wolfganghud_menu_main_menu_name",
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
					{ -- In-Game
						type = "header",
						text_id = "wolfganghud_menu_ingame_name",
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
					{
						type = "toggle",
						name_id = "wolfganghud_no_debriefing_title",
						value = {"MENU", "NO_DEBRIEFING"},
						visible_reqs = {},
						enabled_reqs = {},
					},
				},
			},
			{	-- Gameplay
				type = "menu",
				menu_id = "wolfganghud_gameplay_options_name",
				name_id = "wolfganghud_gameplay_options_name",
				visible_reqs = {},
				enabled_reqs = {},
				options = {
					{ -- General
						y_offset = 320,
						type = "header",
						text_id = "wolfganghud_gameplay_general_name",
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
					{ -- Hardcore
						type = "header",
						text_id = "wolfganghud_gameplay_hardcore_name",
					},
					{
						type = "toggle",
						name_id = "wolfganghud_realistic_reload_title",
						value = {"GAMEPLAY", "REALISTIC_RELOAD"},
						visible_reqs = {},
						enabled_reqs = {},
					},
					--[[
					{ -- Cheesy
						type = "header",
						text_id = "wolfganghud_gameplay_cheesy_name",
					},
					{
						type = "toggle",
						name_id = "wolfganghud_auto_apply_weapon_skills_title",
						value = {"GAMEPLAY", "AUTO_APPLY_WEAPON_SKILLS"},
						visible_reqs = {},
						enabled_reqs = {},
					},]]
				},
			},
			{	-- Hosting
				type = "menu",
				menu_id = "wolfganghud_host_options_name",
				name_id = "wolfganghud_host_options_name",
				visible_reqs = {},
				enabled_reqs = {},
				options = {
					{ -- General
						y_offset = 320,
						type = "header",
						text_id = "wolfganghud_hosting_general_name",
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
				},
			},
		}
	}
end
