if WolfgangHUD then
	WolfgangHUD.options_menu_data = {
		type = "menu",
		menu_id = "wolfganghud_main_options_menu",
		name_id = "wolfganghud_options_name",
		options = {
			{
				type = "button",
				name_id = "wolfganghud_reset_options_title",
				clbk = "Reset",
			},
			{
				type = "divider",
				size = 12,
			},
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
			{
				type = "divider",
				size = 12,
			},
			{	-- HUD
				type = "menu",
				menu_id = "wolfganghud_hud_options_menu",
				name_id = "wolfganghud_panels_options_name",
				options = {
					{ -- Accuracy
						type = "toggle",
						name_id = "wolfganghud_killcounter_player_show_accuracy_title",
						visible_reqs = {},
						enabled_reqs = {},
						value = {"HUD", "PLAYER", "SHOW_ACCURACY"},
					},
					{
						type = "divider",
						size = 12,
					},
					{	-- KillCounters
						type = "menu",
						menu_id = "wolfganghud_killcounter_options_menu",
						name_id = "wolfganghud_killcounter_options_name",
						options = {
							{
								type = "toggle",
								name_id = "wolfganghud_killcounter_player_show_killcount_title",
								visible_reqs = {},
								enabled_reqs = {},
								value = {"HUD", "PLAYER", "KILLCOUNTER", "HIDE"},
								invert_value = true,
							},
							{
								type = "toggle",
								name_id = "wolfganghud_killcounter_player_show_special_title",
								visible_reqs = {},
								enabled_reqs = {
									{ setting = {"HUD", "PLAYER", "KILLCOUNTER", "HIDE"}, invert = true }
								},
								value = {"HUD", "PLAYER", "KILLCOUNTER", "SHOW_SPECIAL_KILLS"},
							},
							{
								type = "toggle",
								name_id = "wolfganghud_killcounter_player_show_head_title",
								visible_reqs = {},
								enabled_reqs = {
									{ setting = {"HUD", "PLAYER", "KILLCOUNTER", "HIDE"}, invert = true }
								},
								value = {"HUD", "PLAYER", "KILLCOUNTER", "SHOW_HEADSHOT_KILLS"},
							},
							{
								type = "multi_choice",
								name_id = "wolfganghud_killcounter_player_color_title",
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
								size = 12,
							},
							{
								type = "toggle",
								name_id = "wolfganghud_killcounter_team_show_killcount_title",
								visible_reqs = {},
								enabled_reqs = {},
								value = {"HUD", "TEAMMATE", "KILLCOUNTER", "HIDE"},
								invert_value = true,
							},
							{
								type = "toggle",
								name_id = "wolfganghud_killcounter_team_show_special_title",
								visible_reqs = {},
								enabled_reqs = {
									{ setting = {"HUD", "TEAMMATE", "KILLCOUNTER", "HIDE"}, invert = true }
								},
								value = {"HUD", "TEAMMATE", "KILLCOUNTER", "SHOW_SPECIAL_KILLS"},
							},
							{
								type = "toggle",
								name_id = "wolfganghud_killcounter_team_show_head_title",
								visible_reqs = {},
								enabled_reqs = {
									{ setting = {"HUD", "TEAMMATE", "KILLCOUNTER", "HIDE"}, invert = true }
								},
								value = {"HUD", "TEAMMATE", "KILLCOUNTER", "SHOW_HEADSHOT_KILLS"},
							},
							{
								type = "toggle",
								name_id = "wolfganghud_killcounter_team_show_ai_title",
								visible_reqs = {},
								enabled_reqs = {
									{ setting = {"HUD", "TEAMMATE", "KILLCOUNTER", "HIDE"}, invert = true }
								},
								value = {"HUD", "TEAMMATE", "KILLCOUNTER", "SHOW_BOT_KILLS"},
							},
							{
								type = "multi_choice",
								name_id = "wolfganghud_killcounter_team_color_title",
								value = {"HUD", "TEAMMATE", "KILLCOUNTER", "COLOR"},
								visible_reqs = {},
								enabled_reqs = {
									{ setting = {"HUD", "TEAMMATE", "KILLCOUNTER", "HIDE"}, invert = true }
								},
								options = {},
								add_color_options = true,
								add_rainbow = false,
							},
						},
					},
				},
			},
		},
	}
end
