if string.lower(RequiredScript) == "lib/managers/menu/raid_menu/controls/raidguicontrollistitemraids" then
    local _layout_raid_name_original = RaidGUIControlListItemRaids._layout_raid_name

    local icon_size = tweak_data.gui.font_sizes.small - 2
    --local icon_color = tweak_data.gui.colors.raid_dirty_white
    local partially_stealthable = {
        ["fury_railway"] = true,  -- Gold Diggers               // ends when closing gate
        ["radio_defense"] = true, -- Wiretap                    // ends when Lange climbed the tower
        ["bunker_test"] = true,   -- Bunker Busters             // ends when blowing up the dynamite
        ["spies_test"] = true,    -- Extraction                 // ends when using the radio
        ["tutorial"] = true,      -- 'Tutorial Online' compat   // ends when warcry is shown to the player
        ["fake_mission_clear_skies_radio_defense"] = true, -- 'Operation days as missions' compat (London calling / clear skies 4/6)
    }

    function RaidGUIControlListItemRaids:_layout_raid_name(params, data, ...)
        _layout_raid_name_original(self, params, data, ...)
        if not self._object or not self._item_label or not data.value or not WolfgangHUD:getSetting({ "MENU", "MARK_STEALTHABLES" }, true) then
            return
        end

        local raid_data = tweak_data.operations.missions[data.value]
        if raid_data.start_in_stealth then
            local x, _, w, _ = self._item_label:text_rect()
            self._stealhtable_icon = self:_init_stealthable_icon(x + w + 4, 0, raid_data.stealth_bonus == nil or partially_stealthable[data.value])
            self._stealhtable_icon:set_center_y(RaidGUIControlListItemRaids.NAME_CENTER_Y)
        end
    end

    function RaidGUIControlListItemRaids:_init_stealthable_icon(x, y, partially)
        return self._object:bitmap({
            texture = "ui/hud/atlas/raid_atlas_waypoints",
            texture_rect = { 439, 437, 38, 38 },
            x = x,
            y = y,
            w = icon_size,
            h = icon_size,
            blend_mode = "normal",
            color = partially and tweak_data.gui.colors.raid_grey or tweak_data.gui.colors.progress_green
        })
    end
end
