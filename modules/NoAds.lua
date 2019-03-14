if not (WolfgangHUD and WolfgangHUD:getSetting({"MENU", "REMOVE_AD_BOX"}, true)) then return end

if string.lower(RequiredScript) == "lib/managers/menu/raid_menu/raidmainmenugui" then

	function RaidMainMenuGui:_layout_steam_group_button(...)
		-- nope
	end

	function RaidMainMenuGui:mouse_over_steam_group_button(...)
		-- nope
	end

	function RaidMainMenuGui:mouse_exit_steam_group_button(...)
		-- nope
	end

	function RaidMainMenuGui:mouse_pressed_steam_group_button(...)
		-- nope
	end

	function RaidMainMenuGui:mouse_released_steam_group_button(...)
		-- nope
	end

	function RaidMainMenuGui:_animate_steam_group_button_press(o, ...)
		-- nope
	end

	function RaidMainMenuGui:_animate_steam_group_button_release(o, ...)
		-- nope
	end

end