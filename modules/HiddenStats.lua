if string.lower(RequiredScript) == "lib/managers/menu/raid_menu/controls/raidguicontrolweaponstats" then
    local init_original = RaidGUIControlWeaponStats.init
    local _create_items_original = RaidGUIControlWeaponStats._create_items
    local _set_default_values_original = RaidGUIControlWeaponStats._set_default_values
    local _get_tabs_params_original = RaidGUIControlWeaponStats._get_tabs_params
    local set_modified_stats_original = RaidGUIControlWeaponStats.set_modified_stats
    local set_applied_stats_original = RaidGUIControlWeaponStats.set_applied_stats

    RaidGUIControlWeaponStats.WGFLAG_WEAPONS = 1
    RaidGUIControlWeaponStats.WGFLAG_GRENADES = 2
    RaidGUIControlWeaponStats.WGFLAG_MELEE = 3

    local function f2s(val)
        return tostring(math.round_with_precision(val, 1))
    end

    RaidGUIControlWeaponStats.WG_HIDDEN_STATS = {
        {
            name = "zoom",
            getter = function(_, parts, _, _, tweak_stats, tweak_wpn)
                local fov = tweak_stats.zoom[math.min(
                    ((tweak_wpn.stats and tweak_wpn.stats.zoom or 2))
                    + (parts.zoom or 0)
                    + managers.player:upgrade_value(tweak_wpn.category, "zoom_increase", 0),
                    #tweak_stats.zoom)]
                return f2s((100 - fov) / 35) -- fictional formula, which should make most sense for the end user (i hope)
            end,
            visible_flags = {
                RaidGUIControlWeaponStats.WGFLAG_WEAPONS,
                --RaidGUIControlWeaponStats.WGFLAG_GRENADES, -- disabled for now, because all are equal (1) as of U21.6
                --RaidGUIControlWeaponStats.WGFLAG_MELEE -- disabled for now, because all are equal (1) as of U21.6
            }
        },
        -- { -- couldnt make any logical sense out of these values, so lets still hide them for now
        --     name = "suppression",
        --     getter = function(base, parts, mods, skill, tweak_stats, tweak_wpn)
        --         return (tweak_wpn.SUPPRESSION or tweak_wpn.suppression) or
        --             tweak_stats.suppression[math.clamp((base.suppression and base.suppression.value or 16)
        --                 + (parts.suppression or 0)
        --                 + (mods.suppression and mods.suppression.value or 0)
        --                 + (skill.suppression and skill.suppression.value or 0),
        --                 1,
        --                 #tweak_stats.suppression
        --             )]
        --     end,
        --     visible_flags = {
        --         RaidGUIControlWeaponStats.WGFLAG_WEAPONS,
        --         --RaidGUIControlWeaponStats.WGFLAG_GRENADES, -- disabled for now, because all are equal (1) as of U21.6
        --         --RaidGUIControlWeaponStats.WGFLAG_MELEE -- disabled for now, because all are equal (1) as of U21.6
        --     }
        -- },
        { -- we could convert these to a "suspicion" value, but we know concealment from pd2, so most people are used to it
            name = "concealment",
            getter = function(base, parts, mods, skill, _, tweak_wpn)
                return (tweak_wpn.concealment or (base.concealment and base.concealment.value or 0))
                    + (parts.concealment or 0)
                    + (mods.concealment and mods.concealment.value or 0)
                    + (skill.concealment and skill.concealment.value or 0)
            end,
            visible_flags = {
                RaidGUIControlWeaponStats.WGFLAG_WEAPONS,
                --RaidGUIControlWeaponStats.WGFLAG_GRENADES, -- bs
                --RaidGUIControlWeaponStats.WGFLAG_MELEE -- disabled for now, because all are equal (30) as of U21.6
            }
        },
        {
            name = "alert_size",
            getter = function(_, parts, _, _, tweak_stats, tweak_wpn)
                if tweak_wpn.stat_group == "distraction" then
                    return "-" -- ignore coin
                end
                return
                -- grenades
                    tweak_wpn.alert_size
                    or
                    -- weapons
                    tweak_stats.alert_size[math.clamp(
                        (tweak_wpn.stats and tweak_wpn.stats.alert_size or 20)
                        + (parts.alert_size or 0),
                        1,
                        #tweak_stats.alert_size)]
            end,
            visible_flags = {
                RaidGUIControlWeaponStats.WGFLAG_WEAPONS,
                RaidGUIControlWeaponStats.WGFLAG_GRENADES,
                --RaidGUIControlWeaponStats.WGFLAG_MELEE -- bs
            }
        },
    }

    function RaidGUIControlWeaponStats:init(parent, params, ...)
        self._wg_flag = self._wg_flag or RaidGUIControlWeaponStats.WGFLAG_WEAPONS
        self._wg_show_hidden_stats = WolfgangHUD:getSetting({ "MENU", "SHOW_HIDDEN_WEAPON_STATS" }, true)
        self._wg_convert_sizes_to_meters = WolfgangHUD:getSetting({ "MENU", "CONVERT_SIZES_TO_METERS" }, true)

        if self._wg_show_hidden_stats and (self._wg_flag == RaidGUIControlWeaponStats.WGFLAG_WEAPONS) then
            params.tab_width = 120
        end

        local result = init_original(self, parent, params, ...)

        -- if self._wg_show_hidden_stats and (self._wg_flag == RaidGUIControlWeaponStats.WGFLAG_WEAPONS) then
        --     self:set_x(500)
        -- end

        return result
    end

    function RaidGUIControlWeaponStats:_create_items(...)
        local result = _create_items_original(self, ...)

        if self._params.tabs_params and (self._wg_flag == RaidGUIControlWeaponStats.WGFLAG_WEAPONS) and self._items and #self._items > 0 then
            for _, item in ipairs(self._items) do
                local label_value = item._label._label_value
                if label_value then
                    label_value:set_font_size(tweak_data.gui.font_sizes.size_38)
                end
                local label_value_with_delta = item._label._label_value_with_delta
                if label_value_with_delta then
                    label_value_with_delta:set_font_size(tweak_data.gui.font_sizes.medium)
                end
                local label_text = item._label._label_text
                if label_text then
                    label_text:set_font_size(tweak_data.gui.font_sizes.extra_small)
                end
            end
        end

        return result
    end

    function RaidGUIControlWeaponStats:_set_default_values(...)
        local result = _set_default_values_original(self, ...)

        if self._wg_show_hidden_stats then
            self:wg_set_hidden_default_values()
        end

        return result
    end

    function RaidGUIControlWeaponStats:_get_tabs_params(...)
        local tabs_params = _get_tabs_params_original(self, ...)

        if self._wg_show_hidden_stats then
            tabs_params = self:wg_attach_hidden_tabs_params(tabs_params)
        end

        return tabs_params
    end

    function RaidGUIControlWeaponStats:set_modified_stats(params, ...)
        if self._wg_show_hidden_stats then
            for stat_name, value in pairs(self:wg_get_selected_weapon_hidden_stats()) do
                self._values[stat_name].modified_value = value
            end
        end

        return set_modified_stats_original(self, params, ...)
    end

    function RaidGUIControlWeaponStats:set_applied_stats(params, ...)
        if self._wg_show_hidden_stats then
            for stat_name, value in pairs(self:wg_get_selected_weapon_hidden_stats()) do
                self._values[stat_name].applied_value = value
            end
        end

        return set_applied_stats_original(self, params, ...)
    end

    function RaidGUIControlWeaponStats:wg_set_hidden_default_values()
        for _, stat in ipairs(self.WG_HIDDEN_STATS) do
            if table.contains(stat.visible_flags, self._wg_flag) then
                self._values[stat.name] = {
                    value = "00",
                    delta_value = "00",
                    text = string.upper(self:translate("wolfganghud_menu_weapons_stats_" .. stat.name, true))
                }
            end
        end
    end

    function RaidGUIControlWeaponStats:wg_attach_hidden_tabs_params(tabs_params)
        for _, stat in ipairs(self.WG_HIDDEN_STATS) do
            if table.contains(stat.visible_flags, self._wg_flag) then
                table.insert(tabs_params, {
                    name = stat.name,
                    text = self._values[stat.name].text,
                    modified_value = self._values[stat.name].modified_value or 0,
                    applied_value = self._values[stat.name].applied_value or 0
                })
            end
        end

        return tabs_params
    end

    function RaidGUIControlWeaponStats:wg_get_selected_weapon_hidden_stats()
        local result = {}
        local shown_stats = {}
        for _, stat in ipairs(self.WG_HIDDEN_STATS) do
            if table.contains(stat.visible_flags, self._wg_flag) then
                result[stat.name] = 0
                table.insert(shown_stats, stat)
            end
        end

        if managers.menu_component then
            local weapon_select_gui = managers.menu_component._raid_menu_weapon_select_gui
            if weapon_select_gui then
                local selected_item = weapon_select_gui._weapon_list:selected_item()
                if selected_item then
                    local selected_weapon_data = selected_item:data().value
                    local weapon_id = selected_weapon_data.weapon_id
                    local weapon_category_id = weapon_select_gui._selected_weapon_category_id
                    local weapon_category = managers.weapon_inventory:get_weapon_category_by_weapon_category_id(
                        weapon_category_id)

                    local tweak_stats = tweak_data.weapon.stats
                    local tweak_weapon = tweak_data.weapon[weapon_id]
                    local weapon_factory_id = managers.weapon_factory:get_factory_id_by_weapon_id(weapon_id)
                    local blueprint = managers.weapon_skills:recreate_weapon_blueprint(weapon_id, weapon_category_id,
                        nil, false)
                    local parts_stats = managers.weapon_factory:get_stats(weapon_factory_id, blueprint)

                    local base_stats, mods_stats, skill_stats = {}, {}, {}
                    if weapon_category == WeaponInventoryManager.BM_CATEGORY_PRIMARY_NAME or weapon_category == WeaponInventoryManager.BM_CATEGORY_SECONDARY_NAME then
                        base_stats, mods_stats, skill_stats = managers.weapon_inventory:get_weapon_stats(weapon_id,
                            weapon_category, selected_weapon_data.slot, nil)
                    elseif weapon_category == WeaponInventoryManager.BM_CATEGORY_MELEE_NAME then
                        base_stats, mods_stats, skill_stats = managers.weapon_inventory:get_melee_weapon_stats(weapon_id)
                        tweak_weapon = tweak_data.blackmarket.melee_weapons[weapon_id]
                    end

                    for _, stat in ipairs(shown_stats) do
                        local value = stat.getter(base_stats, parts_stats, mods_stats, skill_stats, tweak_stats,
                            tweak_weapon) or 0
                        if self._wg_convert_sizes_to_meters and stat.name == "alert_size" and tonumber(value) then
                            value = tonumber(value) / 100
                        end
                        result[stat.name] = value
                    end

                    return result
                end
            end
        end

        return result
    end
elseif string.lower(RequiredScript) == "lib/managers/menu/raid_menu/controls/raidguicontrolgrenadeweaponstats" then
    local init_original = RaidGUIControlGrenadeWeaponStats.init
    local _set_default_values_original = RaidGUIControlGrenadeWeaponStats._set_default_values
    local _get_tabs_params_original = RaidGUIControlGrenadeWeaponStats._get_tabs_params
    local set_stats_original = RaidGUIControlGrenadeWeaponStats.set_stats

    function RaidGUIControlGrenadeWeaponStats:init(parent, params, ...)
        self._wg_flag = RaidGUIControlWeaponStats.WGFLAG_GRENADES
        self._wg_show_hidden_stats = WolfgangHUD:getSetting({ "MENU", "SHOW_HIDDEN_WEAPON_STATS" }, true)
        self._wg_convert_sizes_to_meters = WolfgangHUD:getSetting({ "MENU", "CONVERT_SIZES_TO_METERS" }, true)
        return init_original(self, parent, params, ...)
    end

    function RaidGUIControlGrenadeWeaponStats:_set_default_values(...)
        local result = _set_default_values_original(self, ...)

        if self._wg_show_hidden_stats then
            self:wg_set_hidden_default_values()
        end

        return result
    end

    function RaidGUIControlGrenadeWeaponStats:_get_tabs_params(...)
        local tabs_params = _get_tabs_params_original(self, ...)

        if self._wg_show_hidden_stats then
            tabs_params = self:wg_attach_hidden_tabs_params(tabs_params)
        end

        return tabs_params
    end

    function RaidGUIControlGrenadeWeaponStats:set_stats(damage, range, distance, ...)
        if self._wg_show_hidden_stats then
            for stat_name, value in pairs(self:wg_get_selected_weapon_hidden_stats()) do
                self._values[stat_name].value = value
            end
        end

        if self._wg_convert_sizes_to_meters then
            range = range / 100
            distance = distance / 100
        end

        return set_stats_original(self, damage, range, distance, ...)
    end
elseif string.lower(RequiredScript) == "lib/managers/menu/raid_menu/controls/raidguicontrolmeleeweaponstats" then
    local init_original = RaidGUIControlMeleeWeaponStats.init
    local _set_default_values_original = RaidGUIControlMeleeWeaponStats._set_default_values
    local _get_tabs_params_original = RaidGUIControlMeleeWeaponStats._get_tabs_params
    local set_stats_original = RaidGUIControlMeleeWeaponStats.set_stats

    function RaidGUIControlMeleeWeaponStats:init(parent, params, ...)
        self._wg_flag = RaidGUIControlWeaponStats.WGFLAG_MELEE
        self._wg_show_hidden_stats = WolfgangHUD:getSetting({ "MENU", "SHOW_HIDDEN_WEAPON_STATS" }, true)
        self._wg_convert_sizes_to_meters = WolfgangHUD:getSetting({ "MENU", "CONVERT_SIZES_TO_METERS" }, true)
        return init_original(self, parent, params, ...)
    end

    function RaidGUIControlMeleeWeaponStats:_set_default_values(...)
        local result = _set_default_values_original(self, ...)

        if self._wg_show_hidden_stats then
            self:wg_set_hidden_default_values()
        end

        return result
    end

    function RaidGUIControlMeleeWeaponStats:_get_tabs_params(...)
        local tabs_params = _get_tabs_params_original(self, ...)

        if self._wg_show_hidden_stats then
            tabs_params = self:wg_attach_hidden_tabs_params(tabs_params)
        end

        return tabs_params
    end

    function RaidGUIControlMeleeWeaponStats:set_stats(damage, knockback, range, charge_time, ...)
        if self._wg_show_hidden_stats then
            for stat_name, value in pairs(self:wg_get_selected_weapon_hidden_stats()) do
                self._values[stat_name].value = value
            end
        end

        return set_stats_original(self, damage, knockback, range, charge_time, ...)
    end
elseif string.lower(RequiredScript) == "lib/managers/menu/menucomponentmanager" then
    local _create_raid_menu_weapon_select_gui_original = MenuComponentManager._create_raid_menu_weapon_select_gui

    function MenuComponentManager:_create_raid_menu_weapon_select_gui(node, component, ...)
        local result = _create_raid_menu_weapon_select_gui_original(self, node, component, ...)

        if result._weapon_stats._wg_show_hidden_stats then
            result:_update_weapon_stats(true) -- force reload once more (needed to fix hidden stats initial value, as managers.menu_component is still nil when wg_get_selected_weapon_hidden_stats is called first time)
        end

        return result
    end
elseif string.lower(RequiredScript) == "lib/managers/menu/raid_menu/weaponselectiongui" then
    local _layout_original = WeaponSelectionGui._layout
    local _equip_weapon_original = WeaponSelectionGui._equip_weapon

    function WeaponSelectionGui:_layout(...)
        local result = _layout_original(self, ...)

        self._wg_show_detection_risk = WolfgangHUD:getSetting({ "MENU", "SHOW_DETECTION_RISK" }, true)

        if self._wg_show_detection_risk then
            self:wg_layout_detection_risk_panel()
        end

        return result
    end

    function WeaponSelectionGui:_equip_weapon(...)
        local result = _equip_weapon_original(self, ...)

        if self._wg_show_detection_risk then
            self:wg_update_detection_risk()
        end

        return result
    end

    function WeaponSelectionGui:wg_layout_detection_risk_panel()
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

        self:wg_create_eye_background()
        self:wg_create_eye_outside_ring()
        self:wg_create_eye_fill()

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

        self:wg_update_detection_risk()
    end

    function WeaponSelectionGui:wg_create_eye_background()
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

    function WeaponSelectionGui:wg_create_eye_outside_ring()
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

    function WeaponSelectionGui:wg_create_eye_fill()
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

    function WeaponSelectionGui:wg_update_detection_risk()
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
