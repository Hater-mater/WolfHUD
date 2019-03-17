if string.lower(RequiredScript) == "lib/managers/hud/hudchat" then

	local key_press_original = HUDChat.key_press

	function HUDChat:key_press(o, k)
		if self._skip_first then
			self._skip_first = false
			return
		end
		if k == Idstring("num enter") and WolfgangHUD:getSetting({"MENU", "READY_UP_ON_NUM_ENTER"}, true) then
			if managers.menu_component and
					managers.menu_component._raid_ready_up_gui and
					managers.menu_component._raid_ready_up_gui._ready_up_button and
					managers.menu_component._raid_ready_up_gui._ready_up_button:enabled() and
					not managers.menu_component._raid_ready_up_gui._ready then
				managers.menu_component._raid_ready_up_gui:_on_ready_up_button()
				return
			end
		end
		key_press_original(self, o, k)
	end

end