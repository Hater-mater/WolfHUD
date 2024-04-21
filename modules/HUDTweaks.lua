if string.lower(RequiredScript) == "lib/managers/hud/hudteammatebase" then
    function HUDTeammateBase:wh_refresh_level()
        self._player_level:set_x(0)
        self._player_level:set_y(1)
        self._player_level:set_h(self._player_name:h())
        self._player_level:set_halign(self._player_name:halign())
        self._player_level:set_font_size(self._player_name:font_size())
        self:wh_refresh_name()
    end

    function HUDTeammateBase:wh_refresh_name()
        self._player_name:set_x(self._player_level:w() + 4)
        local name_w = select(3, self._player_name:text_rect())
        local chat_x = math.min(name_w, self._player_name:w())
        self._voice_chat_panel:set_left(self._player_name:x() + chat_x)
        self._voice_chat_panel:set_top(self._player_name:y())
    end
elseif string.lower(RequiredScript) == "lib/managers/hud/hudteammatepeer" then
    local set_name_original = HUDTeammatePeer.set_name
    local set_level_original = HUDTeammatePeer.set_level

    function HUDTeammatePeer:set_name(name, ...)
        set_name_original(self, name, ...)
        if self._player_name and managers.criminals
            and WolfgangHUD:getSetting({ "HUD", "COLORIZE_NAMES" }, false) then
            self._player_name:set_color(
                tweak_data.chat_colors
                [managers.criminals:character_color_id_by_name(managers.criminals:character_name_by_panel_id(self._id))]
            )
            if WolfgangHUD:getSetting({ "HUD", "LEVELS_BEFORE_NAME" }, false) then
                self:wh_refresh_name()
            end
        end
    end

    function HUDTeammatePeer:set_level(level, ...)
        set_level_original(self, level, ...)
        if WolfgangHUD:getSetting({ "HUD", "LEVELS_BEFORE_NAME" }, false) then
            self:wh_refresh_level()
        end
    end
elseif string.lower(RequiredScript) == "lib/managers/hud/hudteammateplayer" then
    local set_name_original = HUDTeammatePlayer.set_name
    local set_level_original = HUDTeammatePlayer.set_level

    function HUDTeammatePlayer:set_name(name, ...)
        set_name_original(self, name, ...)
        if self._player_name and managers.criminals and managers.player
            and WolfgangHUD:getSetting({ "HUD", "COLORIZE_NAMES" }, false) then
            self._player_name:set_color(
                tweak_data.chat_colors
                [managers.criminals:character_color_id_by_unit(managers.player:player_unit())]
            )
            if WolfgangHUD:getSetting({ "HUD", "LEVELS_BEFORE_NAME" }, false) then
                self:wh_refresh_name()
            end
        end
    end

    function HUDTeammatePlayer:set_level(level, ...)
        set_level_original(self, level, ...)
        if WolfgangHUD:getSetting({ "HUD", "LEVELS_BEFORE_NAME" }, false) then
            self:wh_refresh_level()
        end
    end
end
