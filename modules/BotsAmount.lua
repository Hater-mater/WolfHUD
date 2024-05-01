if string.lower(RequiredScript) == "lib/managers/menu/raid_menu/missionselectiongui" then
    local _layout_settings_original = MissionSelectionGui._layout_settings
    local _layout_settings_offline_original = MissionSelectionGui._layout_settings_offline
    local _on_toggle_team_ai_original = MissionSelectionGui._on_toggle_team_ai
    local _set_settings_enabled_original = MissionSelectionGui._set_settings_enabled

    function MissionSelectionGui:_layout_settings(...)
        _layout_settings_original(self, ...)
        self:_layout_bots_amount()
    end

    function MissionSelectionGui:_layout_settings_offline(...)
        _layout_settings_offline_original(self, ...)
        self:_layout_bots_amount()
    end

    function MissionSelectionGui:_layout_bots_amount()
        self._bots_amount_stepper = self._settings_panel:stepper({
            name = "bots_amount_stepper",
            y = self._team_ai_checkbox:y() + self._team_ai_checkbox:h() + MissionSelectionGui.SETTINGS_PADDING,
            x = 0,
            description = self:translate("wolfganghud_menu_bots_amount_title", true),
            on_item_selected_callback = callback(self, self, "_on_bots_amount_selected"),
            data_source_callback = callback(self, self, "data_source_bots_amount_stepper"),
            on_menu_move = {
                left = "audio_button",
                up = "team_ai_checkbox",
            },
            enabled = Global.game_settings.team_ai
        })
        self._bots_amount_stepper:set_value_and_render(WolfgangHUD:getSetting({ "GAMEPLAY", "BOTS_AMOUNT" }, 3),
            true)
        table.insert(self._settings_controls, self._bots_amount_stepper)

        self:_fixup__team_ai_checkbox()
    end

    function MissionSelectionGui:_fixup__team_ai_checkbox()
        self._team_ai_checkbox._on_menu_move.down = "bots_amount_stepper"
    end

    function MissionSelectionGui:data_source_bots_amount_stepper()
        local bots_amounts = {}
        table.insert(bots_amounts, {
            value = 1,
            text = self:translate("wolfganghud_multiselect_1", true)
        })
        table.insert(bots_amounts, {
            value = 2,
            text = self:translate("wolfganghud_multiselect_2", true)
        })
        table.insert(bots_amounts, {
            value = 3,
            text = self:translate("wolfganghud_multiselect_3", true)
        })
        return bots_amounts
    end

    function MissionSelectionGui:_on_toggle_team_ai(button, control, value, ...)
        local result = _on_toggle_team_ai_original(self, button, control, value, ...)

        local old_value = Global.game_settings.team_ai
        if old_value ~= value then
            self._bots_amount_stepper:set_enabled(value)
            self:_update_bots_enabled(value)
        end
        return result
    end

    function MissionSelectionGui:_update_bots_enabled(enabled)
        local ai_state = managers.groupai and managers.groupai:state() or nil
        if not ai_state then
            return
        end

        Global.game_settings.team_ai = enabled          -- SP
        Global.game_settings.selected_team_ai = enabled -- MP
        ai_state:on_criminal_team_AI_enabled_state_changed()
    end

    function MissionSelectionGui:_on_bots_amount_selected(data)
        local old_value = managers.criminals.MAX_NR_TEAM_AI
        local new_value = data.value
        if old_value ~= new_value then
            WolfgangHUD:setSetting({ "GAMEPLAY", "BOTS_AMOUNT" }, new_value)
            WolfgangHUD:Save()

            -- kick/add bots otf, if ingame
            self:_update_bots_amount(new_value)
        end
    end

    function MissionSelectionGui:_update_bots_amount(new_count)
        local ai_state = managers.groupai and managers.groupai:state() or nil
        if not (managers.criminals and ai_state) then
            return
        end

        local old_count = managers.criminals.MAX_NR_TEAM_AI
        local diff = new_count - old_count
        if diff == 0 then
            return
        end

        managers.criminals.MAX_NR_TEAM_AI = new_count
        if diff > 0 then
            ai_state:fill_criminal_team_with_AI(nil)
        elseif diff < 0 then
            for _ = 1, -diff do
                ai_state:remove_one_teamAI()
            end
        end
    end

    function MissionSelectionGui:_set_settings_enabled(enabled, ...)
        _set_settings_enabled_original(self, enabled, ...)
        for _, setting_control in pairs(self._settings_controls) do
            if setting_control and setting_control:name() == "bots_amount_stepper" then
                setting_control:set_enabled(Global.game_settings.team_ai)
            end
        end
    end
elseif string.lower(RequiredScript) == "lib/managers/criminalsmanager" then
    local init_original = CriminalsManager.init

    function CriminalsManager:init(...)
        self.MAX_NR_TEAM_AI = WolfgangHUD:getSetting({ "GAMEPLAY", "BOTS_AMOUNT" }, 3)
        init_original(self, ...)
    end
end
