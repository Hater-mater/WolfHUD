if string.lower(RequiredScript) == "lib/setups/menusetup" then

    local init_game_original = MenuSetup.init_game

    function MenuSetup:init_game(...)
        local gsm = init_game_original(self, ...)
        if WolfgangHUD:getSetting({"MENU", "STRAIGHT_TO_MAIN_MENU"}, false) then
            gsm:set_boot_intro_done(true)
            gsm:change_state_by_name("menu_titlescreen")
        end
        return gsm
    end

elseif string.lower(RequiredScript) == "lib/states/menutitlescreenstate" then

    local get_start_pressed_controller_index_original = MenuTitlescreenState.get_start_pressed_controller_index
    local _load_savegames_done_original = MenuTitlescreenState._load_savegames_done

    function MenuTitlescreenState:get_start_pressed_controller_index(...)
        self.SILENCED = false
        if WolfgangHUD:getSetting({"MENU", "STRAIGHT_TO_MAIN_MENU"}, false) then
            local num_connected = 0
            local keyboard_index = nil
            for index, controller in ipairs(self._controller_list) do
                if controller._was_connected then
                    num_connected = num_connected + 1
                end
                if controller._default_controller_id == "keyboard" then
                    keyboard_index = index
                end
            end
            if num_connected == 1 and keyboard_index ~= nil then
                self.SILENCED = true
                return keyboard_index
            end
        end
        return get_start_pressed_controller_index_original(self, ...)
    end

    function MenuTitlescreenState:_load_savegames_done(...)
        if self.SILENCED then
            self.SILENCED = false
            self:gsm():change_state_by_name("menu_main")
        else
            _load_savegames_done_original(self, ...)
        end
    end

end
