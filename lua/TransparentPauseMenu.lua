
if string.lower(RequiredScript) == "lib/managers/menu/raid_menu/raidmenuscenemanager" then

	Hooks:PostHook(RaidMenuSceneManager, "show_background", "RaidMenuSceneManager_show_background_WolfgangHUD", function(self)
		local bg = self._background_image._panel
		if alive(bg) and not self._pause_menu_enabled or not WolfgangHUD:getSetting({"HUD", "TRANSPARENT_PAUSE_MENU"}, true) then
			bg:show()
		end
	end)

	Hooks:PostHook(RaidMenuSceneManager, "hide_background", "RaidMenuSceneManager_hide_background_WolfgangHUD", function(self)
		local bg = self._background_image._panel
		if alive(bg) then
			bg:hide()
		end
	end)

end