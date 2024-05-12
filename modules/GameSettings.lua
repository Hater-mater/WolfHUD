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

            managers.network:update_matchmake_attributes()
        end

        return result
    end

    function MissionSelectionGui:_on_permission_selected(data, ...)
        local result = _on_permission_selected_original(self, data, ...)

        local old_value = Global.game_settings.permission
        if old_value ~= data.value then
            WolfgangHUD:setSetting({ "GAME_SETTINGS", "PERMISSION" }, table.index_of(tweak_data.permissions, data.value))
            WolfgangHUD:Save()

            Global.game_settings.permission = data.value

            managers.network:session():chk_server_joinable_state()
            managers.network:update_matchmake_attributes()
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

            managers.network:session():chk_server_joinable_state()
            managers.network:update_matchmake_attributes()
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
            Global.DEFAULT_DIFFICULTY = tweak_data.difficulties
                [WolfgangHUD:getSetting({ "GAME_SETTINGS", "DIFFICULTY" }, 2)]
            Global.game_settings.difficulty = Global.DEFAULT_DIFFICULTY
            if not Global.game_settings.single_player then
                Global.DEFAULT_PERMISSION = tweak_data.permissions
                    [WolfgangHUD:getSetting({ "GAME_SETTINGS", "PERMISSION" }, 1)]
                Global.game_settings.permission = Global.DEFAULT_PERMISSION
                Global.game_settings.drop_in_allowed = WolfgangHUD:getSetting({ "GAME_SETTINGS", "DROP_IN_ALLOWED" },
                    true)
                Global.game_settings.selected_team_ai = WolfgangHUD:getSetting({ "GAME_SETTINGS", "TEAM_AI" }, true)
            else
                Global.game_settings.team_ai = WolfgangHUD:getSetting({ "GAME_SETTINGS", "TEAM_AI" }, true)
            end
        end
        return init_original(self, ...)
    end
elseif string.lower(RequiredScript) == "lib/managers/menu/raid_menu/raidmainmenugui" then
    local _layout_original = RaidMainMenuGui._layout
    local _layout_kick_mute_widget_original = RaidMainMenuGui._layout_kick_mute_widget

    function RaidMainMenuGui:_layout(...)
        self._settings_shown = false
        if not (managers.raid_job and managers.raid_job:is_in_tutorial())
            and (managers.platform:rich_presence() == "MPPlaying" or managers.platform:rich_presence() == "MPLobby")
            and Network:is_server()
            and not Global.game_settings.single_player then
            self._settings_shown = true
        end
        _layout_original(self, ...)
        if self._settings_shown then
            self:wg_layout_right_panel()
            self:wg_layout_game_settings()
        end
    end

    function RaidMainMenuGui:_layout_kick_mute_widget(...)
        _layout_kick_mute_widget_original(self, ...)

        if self._settings_shown then
            local offset = self._online_users_count and (self._online_users_count:h() + 77) or 0 -- [Player count instead of ad] compatibility
            self._widget_panel:set_bottom(self._root_panel:h() - 77 - offset)
        end
    end

    function RaidMainMenuGui:wg_layout_right_panel()
        local right_panel_params = {
            name = "right_panel",
            h = 640,
            y = 192,
            w = 480,
            x = 0,
            layer = 1
        }

        self._right_panel = self._root_panel:panel(right_panel_params)
        self._right_panel:set_x(self._root_panel:w() - self._right_panel:w())
    end

    function RaidMainMenuGui:wg_layout_game_settings()
        self._settings_controls = {}

        local settings_panel_params = {
            name = "settings_panel"
        }

        self._settings_panel = self._right_panel:panel(settings_panel_params)

        local permission_stepper_params = {
            name = "permission_stepper",
            x = 0,
            y = 0,
            description = self:translate("menu_permission_title", true),
            on_item_selected_callback = callback(self, self, "wg_on_permission_selected"),
            data_source_callback = callback(self, self, "wg_data_source_permission_stepper"),
            on_menu_move = {
                down = "drop_in_checkbox",
                left = "audio_button"
            }
        }

        self._permission_stepper = self._settings_panel:stepper(permission_stepper_params)

        self._permission_stepper:set_value_and_render(Global.game_settings.permission, true)
        table.insert(self._settings_controls, self._permission_stepper)

        local drop_in_checkbox_params = {
            name = "drop_in_checkbox",
            value = true,
            x = 0,
            y = self._permission_stepper:y() + self._permission_stepper:h() + MissionSelectionGui.SETTINGS_PADDING,
            description = self:translate("menu_allow_drop_in_title", true),
            on_click_callback = callback(self, self, "wg_on_toggle_drop_in"),
            on_menu_move = {
                up = "permission_stepper",
                down = "team_ai_checkbox",
                left = "audio_button"
            }
        }

        self._drop_in_checkbox = self._settings_panel:toggle_button(drop_in_checkbox_params)

        self._drop_in_checkbox:set_value_and_render(Global.game_settings.drop_in_allowed)
        table.insert(self._settings_controls, self._drop_in_checkbox)
    end

    function RaidMainMenuGui:wg_data_source_permission_stepper()
        local permissions = {}

        table.insert(permissions, {
            value = "public",
            info = "public",
            text = self:translate("menu_permission_public", true)
        })
        table.insert(permissions, {
            value = "friends_only",
            info = "friends_only",
            text = self:translate("menu_permission_friends", true)
        })
        table.insert(permissions, {
            value = "private",
            info = "private",
            text = self:translate("menu_permission_private", true)
        })

        return permissions
    end

    function RaidMainMenuGui:wg_on_permission_selected(data)
        local old_value = Global.game_settings.permission
        if old_value ~= data.value then
            WolfgangHUD:setSetting({ "GAME_SETTINGS", "PERMISSION" }, table.index_of(tweak_data.permissions, data.value))
            WolfgangHUD:Save()

            Global.game_settings.permission = data.value
            if Global.player_manager then
                Global.player_manager.game_settings_permission = data.value
            end

            managers.network:session():chk_server_joinable_state()
            managers.network:update_matchmake_attributes()
        end
    end

    function RaidMainMenuGui:wg_on_toggle_drop_in(_, _, value)
        local old_value = Global.game_settings.drop_in_allowed
        if old_value ~= value then
            WolfgangHUD:setSetting({ "GAME_SETTINGS", "DROP_IN_ALLOWED" }, value)
            WolfgangHUD:Save()

            Global.game_settings.drop_in_allowed = value
            if Global.player_manager then
                Global.player_manager.game_settings_drop_in_allowed = value
            end

            managers.network:session():chk_server_joinable_state()
            managers.network:update_matchmake_attributes()
        end
    end
end
