if string.lower(RequiredScript) == "lib/managers/menu/raid_menu/controls/raidguicontrolweaponstats" then
    local _set_default_values_original = RaidGUIControlWeaponStats._set_default_values
    local _get_tabs_params_original = RaidGUIControlWeaponStats._get_tabs_params
    local set_modified_stats_original = RaidGUIControlWeaponStats.set_modified_stats
    local set_applied_stats_original = RaidGUIControlWeaponStats.set_applied_stats

    function RaidGUIControlWeaponStats:_set_default_values(...)
        _set_default_values_original(self, ...)

        self._show_weapon_concealment = WolfgangHUD:getSetting({ "MENU", "SHOW_WEAPON_CONCEALMENT" }, true)

        if self._show_weapon_concealment then
            self._values.concealment = {
                value = "00",
                delta_value = "00",
                text = string.upper(self:translate("wolfganghud_menu_weapons_stats_concealment", true))
            }
        end
    end

    function RaidGUIControlWeaponStats:_get_tabs_params(...)
        local tabs_params = _get_tabs_params_original(self, ...)

        if self._show_weapon_concealment then
            table.insert(tabs_params, {
                name = "concealment",
                text = self._values.concealment.text,
                modified_value = self._values.concealment.modified_value or 0,
                applied_value = self._values.concealment.applied_value or 0
            })
        end

        return tabs_params
    end

    function RaidGUIControlWeaponStats:set_modified_stats(params, ...)
        if self._show_weapon_concealment then
            self._values.concealment.modified_value = self:wghud_get_selected_weapon_concealment()
        end

        set_modified_stats_original(self, params, ...)
    end

    function RaidGUIControlWeaponStats:set_applied_stats(params, ...)
        if self._show_weapon_concealment then
            self._values.concealment.applied_value = self:wghud_get_selected_weapon_concealment()
        end

        set_applied_stats_original(self, params, ...)
    end

    function RaidGUIControlWeaponStats:wghud_get_selected_weapon_concealment()
        local val = 0
        if managers.menu_component and managers.menu_component._raid_menu_weapon_select_gui then
            local selected = managers.menu_component._raid_menu_weapon_select_gui._weapon_list:selected_item()
            if selected then
                val = tweak_data.weapon[selected:data().value.weapon_id].stats.concealment or 0
            end
        end
        val = math.floor(val * 10) / 10
        if val * 10 % 10 ~= 0 then
            return string.format("%.0f", tostring(val))
        else
            return tostring(val)
        end
    end
elseif string.lower(RequiredScript) == "lib/managers/menu/menucomponentmanager" then
    local _create_raid_menu_weapon_select_gui_original = MenuComponentManager._create_raid_menu_weapon_select_gui

    function MenuComponentManager:_create_raid_menu_weapon_select_gui(node, component, ...)
        local result = _create_raid_menu_weapon_select_gui_original(self, node, component, ...)

        if result._weapon_stats._show_weapon_concealment then
            result:_update_weapon_stats(true) -- force reload once more (fixes init weapon concealment as managers.menu_component is still nil when wghud_get_selected_weapon_concealment is called first time)
        end

        return result
    end
elseif string.lower(RequiredScript) == "lib/managers/menu/raid_menu/weaponselectiongui" then
    local _layout_original = WeaponSelectionGui._layout
    local _equip_weapon_original = WeaponSelectionGui._equip_weapon

    function WeaponSelectionGui:_layout(...)
        _layout_original(self, ...)

        self._show_detection_risk = WolfgangHUD:getSetting({ "MENU", "SHOW_DETECTION_RISK" }, true)

        if self._show_detection_risk then
            self:_layout_detection_risk_panel()
        end
    end

    function WeaponSelectionGui:_layout_detection_risk_panel()
        local footer = managers.menu_component._active_components.raid_menu_footer.component_object

        local name_and_gold_panel = footer._name_and_gold_panel
        local profile_name_label = footer._profile_name_label
        local footer_object = footer._object

        local w = 500
        local h = profile_name_label:h()
        local x = 0
        local y = profile_name_label:y()

        self._detection_risk_separator = footer_object:rect({
            vertical = "bottom",
            name = "detection_risk_separator",
            h = 14,
            y = 14,
            w = 2,
            x = name_and_gold_panel:x() - RaidGuiBase.PADDING,
            color = tweak_data.gui.colors.raid_grey,
            layer = footer_object:layer()
        })

        self._detection_risk_panel = footer_object:panel({
            name = "detection_risk_panel",
            y = 0,
            align = "right",
            x = self._detection_risk_separator:x() - RaidGuiBase.PADDING - w,
            w = w,
            h = footer_object:h()
        })

        self:_create_eye_background()
        self:_create_eye_outside_ring()
        self:_create_eye_fill()

        self._detection_risk_label = self._detection_risk_panel:label({
            name = "detection_risk",
            text = self:translate("wolfganghud_menu_weapons_detection_risk", true) .. ": 00%",
            align = "right",
            vertical = "bottom",
            h = h,
            type = "label",
            y = y,
            x = x,
            w = w - RaidGuiBase.PADDING * 1.2,
            color = tweak_data.gui.colors.raid_grey,
            font = tweak_data.gui.fonts.din_compressed,
            font_size = tweak_data.gui.font_sizes.size_24
        })

        self:_update_detection_risk()
    end

    function WeaponSelectionGui:_create_eye_background()
        local eye_panel_params = {
            halign = "scale",
            name = "eye_panel",
            valign = "scale",
            w = RaidGuiBase.PADDING,
            h = RaidGuiBase.PADDING,
            x = self._detection_risk_panel:w() - RaidGuiBase.PADDING
        }

        self._eye_panel = self._detection_risk_panel:panel(eye_panel_params)

        local eye_background_params = {
            name = "eye_background",
            texture = tweak_data.gui.icons[HUDSuspicionIndicator.EYE_BG_ICON].texture,
            texture_rect = tweak_data.gui.icons[HUDSuspicionIndicator.EYE_BG_ICON].texture_rect,
            layer = self._detection_risk_panel:layer() + 1
        }

        self._eye_background = self._eye_panel:bitmap(eye_background_params)

        self._eye_background:set_center(self._eye_panel:w() / 2, self._eye_panel:h() / 2)
    end

    function WeaponSelectionGui:_create_eye_outside_ring()
        local eye_outside_ring_params = {
            name = "eye_outside_ring",
            texture = tweak_data.gui.icons[HUDSuspicionIndicator.EYE_OUTER_RING_ICON].texture,
            texture_rect = tweak_data.gui.icons[HUDSuspicionIndicator.EYE_OUTER_RING_ICON].texture_rect,
            layer = self._eye_background:layer() + 1,
            color = tweak_data.gui.colors.raid_grey
        }

        self._eye_outside_ring = self._eye_panel:bitmap(eye_outside_ring_params)

        self._eye_outside_ring:set_center(self._eye_background:center())
    end

    function WeaponSelectionGui:_create_eye_fill()
        local eye_fill_params = {
            name = "eye_fill",
            position_z = 0,
            render_template = "VertexColorTexturedRadial",
            texture = tweak_data.gui.icons[HUDSuspicionIndicator.EYE_FILL_ICON].texture,
            texture_rect = {
                tweak_data.gui:icon_w(HUDSuspicionIndicator.EYE_FILL_ICON),
                0,
                -tweak_data.gui:icon_w(HUDSuspicionIndicator.EYE_FILL_ICON),
                tweak_data.gui:icon_h(HUDSuspicionIndicator.EYE_FILL_ICON)
            },
            w = tweak_data.gui:icon_w(HUDSuspicionIndicator.EYE_FILL_ICON),
            h = tweak_data.gui:icon_h(HUDSuspicionIndicator.EYE_FILL_ICON),
            layer = self._eye_background:layer() + 1
        }

        self._eye_fill = self._eye_panel:bitmap(eye_fill_params)

        self._eye_fill:set_center(self._eye_background:center())
    end

    function WeaponSelectionGui:_equip_weapon(...)
        _equip_weapon_original(self, ...)

        if self._show_detection_risk then
            self:_update_detection_risk()
        end
    end

    function WeaponSelectionGui:_update_detection_risk()
        if self._detection_risk_label and managers.blackmarket and tweak_data.player then
            local offset_lerp = tweak_data.player.SUSPICION_OFFSET_LERP or 0.75
            local detection_risk = managers.blackmarket:get_suspicion_offset_of_local(offset_lerp)

            self._detection_risk_label:set_text(
                self:translate("wolfganghud_menu_weapons_detection_risk", true) .. ": " ..
                tostring(math.round(detection_risk * 100)) .. "%"
            )

            if self._eye_fill then
                local color_start = tweak_data.gui.colors.raid_grey
                local color_end = HUDSuspicionIndicator.STATE_COLORS.investigating
                local current_r = Easing.quadratic_in_out(detection_risk, color_start.r, color_end.r - color_start.r,
                    offset_lerp)
                local current_g = Easing.quadratic_in_out(detection_risk, color_start.g, color_end.g - color_start.g,
                    offset_lerp)
                local current_b = Easing.quadratic_in_out(detection_risk, color_start.b, color_end.b - color_start.b,
                    offset_lerp)

                self._eye_fill:set_position_z(detection_risk)
                self._eye_fill:set_color(Color(current_r, current_g, current_b))
            end
        end
    end
end
