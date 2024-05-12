if string.lower(RequiredScript) == "lib/managers/menu/raid_menu/missionselectiongui" then
    local _layout_settings_original = MissionSelectionGui._layout_settings
    local _layout_settings_offline_original = MissionSelectionGui._layout_settings_offline
    local _on_difficulty_selected_original = MissionSelectionGui._on_difficulty_selected
    local _on_permission_selected_original = MissionSelectionGui._on_permission_selected
    local _on_toggle_drop_in_original = MissionSelectionGui._on_toggle_drop_in
    local _on_toggle_team_ai_original = MissionSelectionGui._on_toggle_team_ai
    local _set_settings_enabled_original = MissionSelectionGui._set_settings_enabled

    function MissionSelectionGui:_layout_settings(...)
        _layout_settings_original(self, ...)

        self:wg_layout_bots_amount()
    end

    function MissionSelectionGui:_layout_settings_offline(...)
        _layout_settings_offline_original(self, ...)

        self:wg_layout_bots_amount()
    end

    function MissionSelectionGui:_on_difficulty_selected(data, ...)
        local result = _on_difficulty_selected_original(self, data, ...)

        local old_value = Global.player_manager.game_settings_difficulty
        if old_value ~= data.value then
            WolfgangHUD:setSetting({ "GAME_SETTINGS", "DIFFICULTY" }, table.index_of(tweak_data.difficulties, data.value))
            WolfgangHUD:Save()

            Global.player_manager.game_settings_difficulty = data.value
        end

        return result
    end

    function MissionSelectionGui:_on_permission_selected(data, ...)
        local result = _on_permission_selected_original(self, data, ...)

        local old_value = Global.player_manager.permission
        if old_value ~= data.value then
            WolfgangHUD:setSetting({ "GAME_SETTINGS", "PERMISSION" }, table.index_of(tweak_data.permissions, data.value))
            WolfgangHUD:Save()

            Global.player_manager.permission = data.value
        end

        return result
    end

    function MissionSelectionGui:_on_toggle_drop_in(button, control, value, ...)
        local result = _on_toggle_drop_in_original(self, button, control, value, ...)

        local old_value = Global.game_settings.drop_in_allowed
        if old_value ~= value then
            WolfgangHUD:setSetting({ "GAME_SETTINGS", "DROP_IN_ALLOWED" }, value)
            WolfgangHUD:Save()

            Global.game_settings.drop_in_allowed = value
        end

        return result
    end

    function MissionSelectionGui:_on_toggle_team_ai(button, control, value, ...)
        local result = _on_toggle_team_ai_original(self, button, control, value, ...)

        local old_value = Global.game_settings.single_player and Global.game_settings.team_ai or
            Global.game_settings.selected_team_ai
        if old_value ~= value then
            WolfgangHUD:setSetting({ "GAME_SETTINGS", "TEAM_AI" }, value)
            WolfgangHUD:Save()

            self._bots_amount_stepper:set_enabled(value)
            self:wg_update_bots_enabled(value)
        end

        return result
    end

    function MissionSelectionGui:_set_settings_enabled(enabled, ...)
        _set_settings_enabled_original(self, enabled, ...)
        for _, setting_control in pairs(self._settings_controls) do
            -- disable bots amount stepper if ai is off
            if setting_control and setting_control:name() == "bots_amount_stepper" then
                setting_control:set_enabled(Global.game_settings.single_player and Global.game_settings.team_ai or
                    Global.game_settings.selected_team_ai)
            end
        end
    end

    function MissionSelectionGui:wg_layout_bots_amount()
        self._bots_amount_stepper = self._settings_panel:stepper({
            name = "bots_amount_stepper",
            y = self._team_ai_checkbox:y() + self._team_ai_checkbox:h() + MissionSelectionGui.SETTINGS_PADDING,
            x = 0,
            description = self:translate("wolfganghud_menu_bots_amount_title", true),
            on_item_selected_callback = callback(self, self, "wg_on_bots_amount_selected"),
            data_source_callback = callback(self, self, "data_source_bots_amount_stepper"),
            on_menu_move = {
                left = "audio_button",
                up = "team_ai_checkbox",
            },
            enabled = Global.game_settings.single_player and Global.game_settings.team_ai or
                Global.game_settings.selected_team_ai
        })
        self._bots_amount_stepper:set_value_and_render(WolfgangHUD:getSetting({ "GAME_SETTINGS", "MAX_TEAM_AI" }, 3),
            true)
        table.insert(self._settings_controls, self._bots_amount_stepper)

        self:wg_fixup_team_ai_checkbox()
    end

    function MissionSelectionGui:wg_fixup_team_ai_checkbox()
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

    function MissionSelectionGui:wg_update_bots_enabled(enabled)
        local ai_state = managers.groupai and managers.groupai:state() or nil
        if not ai_state then
            return
        end

        Global.game_settings.team_ai = enabled          -- SP
        Global.game_settings.selected_team_ai = enabled -- MP
        ai_state:on_criminal_team_AI_enabled_state_changed()
    end

    function MissionSelectionGui:wg_on_bots_amount_selected(data)
        local old_value = managers.criminals.MAX_NR_TEAM_AI
        local new_value = data.value
        if old_value ~= new_value then
            WolfgangHUD:setSetting({ "GAME_SETTINGS", "MAX_TEAM_AI" }, new_value)
            WolfgangHUD:Save()

            -- kick/add bots otf, if ingame
            self:wg_update_bots_amount(new_value)
        end
    end

    function MissionSelectionGui:wg_update_bots_amount(new_count)
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
elseif string.lower(RequiredScript) == "lib/managers/criminalsmanager" then
    local init_original = CriminalsManager.init
    local on_mission_end_callback_original = CriminalsManager.on_mission_end_callback

    function CriminalsManager:init(...)
        self.MAX_NR_TEAM_AI = WolfgangHUD:getSetting({ "GAME_SETTINGS", "MAX_TEAM_AI" }, 3)
        init_original(self, ...)
    end

    function CriminalsManager:on_mission_end_callback(...)
        on_mission_end_callback_original(self, ...)
        if Global.game_settings.single_player then
            Global.game_settings.team_ai = WolfgangHUD:getSetting({ "GAME_SETTINGS", "TEAM_AI" }, true)
        else
            Global.game_settings.selected_team_ai = WolfgangHUD:getSetting({ "GAME_SETTINGS", "TEAM_AI" }, true)
        end
    end
elseif string.lower(RequiredScript) == "lib/managers/dynamicresourcemanager" then
    -- chose to hook this, only because it's pretty much the first call in Setup:init_managers, right after building Global.game_settings
    local init_original = DynamicResourceManager.init

    function DynamicResourceManager:init(...)
        if Network:is_server() and Global.game_settings.level_id == OperationsTweakData.ENTRY_POINT_LEVEL then
            Global.game_settings.difficulty = tweak_data.difficulties
                [WolfgangHUD:getSetting({ "GAME_SETTINGS", "DIFFICULTY" }, 2)]
            if not Global.game_settings.single_player then
                Global.game_settings.permission = tweak_data.permissions
                    [WolfgangHUD:getSetting({ "GAME_SETTINGS", "PERMISSION" }, 1)]
                Global.game_settings.drop_in_allowed = WolfgangHUD:getSetting({ "GAME_SETTINGS", "DROP_IN_ALLOWED" },
                    true)
                Global.game_settings.selected_team_ai = WolfgangHUD:getSetting({ "GAME_SETTINGS", "TEAM_AI" }, true)
            else
                Global.game_settings.team_ai = WolfgangHUD:getSetting({ "GAME_SETTINGS", "TEAM_AI" }, true)
            end
        end
        return init_original(self, ...)
    end
end
