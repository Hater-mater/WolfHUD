if string.lower(RequiredScript) == "lib/managers/hudmanagerpd2" then
	local init_original = HUDManager.init

	HUDManager.CUSTOM_WAYPOINTS = {
		DEBUGGING = false,
		DEBUG = {
			alpha = 1,
			angle = 180,
			distance = 99999,
		},
		NORMAL = {
			alpha = 0.1,
			loot_angle = WolfgangHUD:getSetting({ "CustomWaypoints", "LOOT", "ANGLE" }, 20),
			pickups_angle = WolfgangHUD:getSetting({ "CustomWaypoints", "PICKUPS", "ANGLE" }, 35),
			loot_distance = WolfgangHUD:getSetting({ "CustomWaypoints", "LOOT", "DISTANCE" }, 2000),
			pickups_distance = WolfgangHUD:getSetting({ "CustomWaypoints", "PICKUPS", "DISTANCE" }, 3000),
		},
		PICKUPS = {
			ICON_MAP = {

				-- VALUABLES
				consumable_mission = { texture = "ui/atlas/raid_atlas_hud", texture_rect = { 963, 175, 56, 56 } },
				regular_cache_box = { texture = "ui/atlas/raid_atlas_hud", texture_rect = { 677, 1317, 32, 32 } },
				hold_take_loot = { texture = "ui/atlas/raid_atlas_missions", texture_rect = { 8, 68, 64, 64 } },
				press_take_loot = { texture = "ui/atlas/raid_atlas_missions", texture_rect = { 8, 68, 64, 64 } },
				hold_take_dogtags = { texture = "ui/atlas/raid_atlas_missions", texture_rect = { 398, 2, 64, 64 } },
				press_take_dogtags = { texture = "ui/atlas/raid_atlas_missions", texture_rect = { 398, 2, 64, 64 } },

				-- EQUIPMENT
				take_sps_briefcase = { std_icon = "equipment_panel_sps_briefcase" }, -- untested
				--take_code_book =					{std_icon = "equipment_panel_code_book"},
				gen_pku_crowbar = { std_icon = "equipment_panel_crowbar" }, -- FIXME: not working in all raids for some reason
				--dynamite_x1_pku =					{std_icon = "equipment_panel_dynamite_stick"},
				--dynamite_x4_pku =					{std_icon = "equipment_panel_dynamite_stick"},
				--dynamite_x5_pku =					{std_icon = "equipment_panel_dynamite_stick"},
				--take_dynamite_bag =				{std_icon = "equipment_panel_dynamite"},
				hold_take_canister = { std_icon = "equipment_panel_fuel_full" },
				press_take_canister = { std_icon = "equipment_panel_fuel_full" },
				take_enigma = { std_icon = "equipment_panel_code_device" },  -- untested
				hold_take_gas_can = { std_icon = "equipment_panel_fuel_full" }, -- untested
				press_take_gas_can = { std_icon = "equipment_panel_fuel_full" }, -- untested
				take_gas_tank = { std_icon = "equipment_panel_fuel_full" },  -- untested
				--mine_pku =						{std_icon = "equipment_panel_cvy_landimine"},
				take_portable_radio = { std_icon = "equipment_panel_recording_device" }, -- untested
				take_tools = { std_icon = "equipment_panel_tools" },
				take_safe_key = { std_icon = "equipment_panel_sto_safe_key" }, -- untested
				take_safe_keychain = { std_icon = "equipment_panel_sto_safe_key" }, -- untested
				take_tank_grenade = { std_icon = "equipment_panel_dynamite" }, -- untested
				take_tank_shell = { std_icon = "equipment_panel_tools" },    -- untested
				take_thermite = { std_icon = "equipment_panel_cvy_thermite" }, -- untested
				gen_pku_thermite = { std_icon = "equipment_panel_cvy_thermite" }, -- untested
				hold_pku_intelligence = { texture = "ui/atlas/raid_atlas_hud", texture_rect = { 963, 753, 56, 56 } },

				-- PICKUPS
				--health_bag_small =				{skills = {5, 2}},
				--health_bag =						{skills = {5, 2}},
				health_bag_big = { skills = { 2, 9 }, color = WolfgangHUD:getColorSetting({ "CustomWaypoints", "PICKUPS", "REVIVES_COLOR" }, "light_green"), ignore = not WolfgangHUD:getSetting({ "CustomWaypoints", "PICKUPS", "REVIVES" }, true) },
				--ammo_bag_small =					{skills = {4, 2}},
				--ammo_bag =						{skills = {4, 2}},
				--ammo_bag_big =					{skills = {4, 2}},
				--grenade_crate_small =				{skills = {1, 8}},
				--grenade_crate =					{skills = {1, 8}},
				--grenade_crate_big =				{skills = {1, 8}},

				-- FLARES
				--extinguish_flare =				{skills = {0, 2}},
			},
		}
	}

	function HUDManager:init(...)
		init_original(self, ...)

		self._custom_waypoints_loot = {}
		self._custom_waypoints_pickups = {}
		self:setup_custom_waypoints()
	end

	function HUDManager:setup_custom_waypoints()
		if managers.gameinfo and managers.waypoints then
			if WolfgangHUD:getSetting({ "CustomWaypoints", "LOOT", "SHOW" }, true) then
				managers.gameinfo:register_listener("loot_waypoint_listener", "loot", "add",
					callback(self, self, "custom_waypoint_loot_clbk"))
				managers.gameinfo:register_listener("loot_waypoint_listener", "loot", "remove",
					callback(self, self, "custom_waypoint_loot_clbk"))
				managers.gameinfo:register_listener("loot_waypoint_listener", "loot", "interact",
					callback(self, self, "custom_waypoint_loot_clbk"))
			end

			if WolfgangHUD:getSetting({ "CustomWaypoints", "PICKUPS", "SHOW" }, true) then
				managers.gameinfo:register_listener("equipment_waypoint_listener", "pickup", "add",
					callback(self, self, "custom_waypoint_pickup_clbk"))
				managers.gameinfo:register_listener("equipment_waypoint_listener", "pickup", "remove",
					callback(self, self, "custom_waypoint_pickup_clbk"))
			end
		end
	end

	function HUDManager:custom_waypoint_loot_clbk(event, key, data)
		local id = "loot_wp_" .. key
		local tweak_entry = data.carry_id and tweak_data.carry[data.carry_id]

		if event == "add" then
			if tweak_entry and not tweak_entry.is_vehicle and not tweak_entry.skip_exit_secure and (not string.ends(data.carry_id, "_body")) then
				local debug = HUDManager.CUSTOM_WAYPOINTS.DEBUGGING
				local settings = self:make_loot_waypoint_settings(debug)
				local name_id = data.carry_id and tweak_data.carry[data.carry_id] and
					tweak_data.carry[data.carry_id].name_id
				local bag_name = name_id and managers.localization:to_upper_text(name_id)
				local count = data.count or 1
				if bag_name then
					local params = {
						unit = data.unit,
						offset = Vector3(0, 0, WolfgangHUD:getSetting({ "CustomWaypoints", "LOOT", "OFFSET" }, 15)),
						visible_through_walls = debug,
						alpha = settings.alpha,
						visible_angle = { max = settings.angle },
						visible_distance = { max = settings.distance },
						fade_angle = { start_angle = settings.angle, end_angle = settings.angle - 5, final_scale = 8 },
						scale = 1.5,
						icon = {
							type = "icon",
							show = WolfgangHUD:getSetting({ "CustomWaypoints", "LOOT", "ICON" }, true),
							texture = "ui/ingame/textures/hud/hud_waypoint_icons_01",
							texture_rect = { 96, 0, 32, 32 },
							alpha = 0.5,
							color = WolfgangHUD:getColorSetting({ "CustomWaypoints", "LOOT", "COLOR" }, "white"),
						},
						amount = {
							type = "label",
							show = (count > 1),
							text = string.format("%dx", count),
						},
						label = {
							type = "label",
							show = true,
							text = bag_name,
						},
						debug_txt = {
							type = "label",
							show = debug,
							text = string.format("Editor ID: %s", (data.unit:editor_id() or "N/A")),
						},
						component_order = { { "icon", "amount", "label" }, { "debug_txt" } },
					}

					managers.waypoints:add_waypoint(id, "CustomWaypoint", params)
					table.insert(self._custom_waypoints_loot, id)
				end
			end
		elseif managers.waypoints:get_waypoint(id) then
			if event == "interact" then
				local count = data.count or 1
				managers.waypoints:set_waypoint_label(id, "amount", string.format("%dx", count))
				managers.waypoints:set_waypoint_component_setting(id, "amount", "show", (count > 1))
			elseif event == "remove" then
				managers.waypoints:remove_waypoint(id)
			end
		end
	end

	function HUDManager:make_loot_waypoint_settings(debug)
		return {
			angle = debug and HUDManager.CUSTOM_WAYPOINTS.DEBUG.angle or
				HUDManager.CUSTOM_WAYPOINTS.NORMAL.loot_angle,
			alpha = debug and HUDManager.CUSTOM_WAYPOINTS.DEBUG.alpha or
				HUDManager.CUSTOM_WAYPOINTS.NORMAL.alpha,
			distance = debug and HUDManager.CUSTOM_WAYPOINTS.DEBUG.distance or
				HUDManager.CUSTOM_WAYPOINTS.NORMAL.loot_distance
		}
	end

	function HUDManager:custom_waypoint_pickup_clbk(event, key, data)
		local id = "equipment_wp_" .. key

		if event == "add" then
			local icon_table = HUDManager.CUSTOM_WAYPOINTS.PICKUPS.ICON_MAP
			local icon_data = icon_table[data.interact_id]
			if icon_data and not icon_data.ignore then
				if icon_data.skills then
					icon_data.texture = "ui/atlas/raid_atlas_skills"
					local x, y = unpack(icon_data.skills)
					icon_data.texture_rect = { x * 78 + 2, y * 78 + 2, 76, 76 }
					--elseif ... then
					-- TODO
				end
				local debug = HUDManager.CUSTOM_WAYPOINTS.DEBUGGING
				local settings = self:make_pickups_waypoint_settings(debug)
				local params = {
					unit = data.unit,
					offset = icon_data.offset or
						Vector3(0, 0, WolfgangHUD:getSetting({ "CustomWaypoints", "PICKUPS", "OFFSET" }, 15)),
					hide_on_uninteractable = true,
					visible_through_walls = debug,
					scale = 1.25,
					alpha = settings.alpha,
					fade_angle = { start_angle = settings.angle, end_angle = settings.angle - 5, final_scale = 8 },
					visible_angle = { max = settings.angle },
					visible_distance = { max = settings.distance },
					color = icon_data.color or
						WolfgangHUD:getColorSetting({ "CustomWaypoints", "PICKUPS", "COLOR" }, "white"),
					icon = {
						type = "icon",
						show = true,
						std_wp = icon_data.std_icon,
						texture = icon_data.texture,
						texture_rect = icon_data.texture_rect,
					},
					component_order = { { "icon" } },
				}

				managers.waypoints:add_waypoint(id, "CustomWaypoint", params)
				table.insert(self._custom_waypoints_pickups, id)
			end
		elseif event == "remove" then
			managers.waypoints:remove_waypoint(id)
		end
	end

	function HUDManager:make_pickups_waypoint_settings(debug)
		return {
			angle = debug and HUDManager.CUSTOM_WAYPOINTS.DEBUG.angle or
				HUDManager.CUSTOM_WAYPOINTS.NORMAL.pickups_angle,
			alpha = debug and HUDManager.CUSTOM_WAYPOINTS.DEBUG.alpha or
				HUDManager.CUSTOM_WAYPOINTS.NORMAL.alpha,
			distance = debug and HUDManager.CUSTOM_WAYPOINTS.DEBUG.distance or
				HUDManager.CUSTOM_WAYPOINTS.NORMAL.pickups_distance
		}
	end

	function HUDManager:set_custom_waypoint_debugging(enable)
		if HUDManager.CUSTOM_WAYPOINTS.DEBUGGING ~= enable then
			HUDManager.CUSTOM_WAYPOINTS.DEBUGGING = enable
			local loot_settings = self:make_loot_waypoint_settings(enable)
			for _, id in ipairs(self._custom_waypoints_loot) do
				managers.waypoints:set_waypoint_setting(id, "alpha", loot_settings.alpha)
				managers.waypoints:set_waypoint_setting(id, "visible_through_walls", enable)
				managers.waypoints:set_waypoint_setting(id, "visible_distance", { max = loot_settings.distance })
				managers.waypoints:set_waypoint_setting(id, "visible_angle", { max = loot_settings.angle })
				managers.waypoints:set_waypoint_setting(id, "fade_angle",
					{ start_angle = loot_settings.angle, end_angle = loot_settings.angle - 5, final_scale = 8 })
				managers.waypoints:set_waypoint_component_setting(id, "debug_txt", "show", enable)
			end
			local pickups_settings = self:make_pickups_waypoint_settings(enable)
			for _, id in ipairs(self._custom_waypoints_pickups) do
				managers.waypoints:set_waypoint_setting(id, "alpha", pickups_settings.alpha)
				managers.waypoints:set_waypoint_setting(id, "visible_through_walls", enable)
				managers.waypoints:set_waypoint_setting(id, "visible_distance", { max = pickups_settings.distance })
				managers.waypoints:set_waypoint_setting(id, "visible_angle", { max = pickups_settings.angle })
				managers.waypoints:set_waypoint_setting(id, "fade_angle",
					{ start_angle = pickups_settings.angle, end_angle = pickups_settings.angle - 5, final_scale = 8 })
			end
		end
	end
end

if string.lower(RequiredScript) == "lib/units/vehicles/vehicledrivingext" then
	local add_loot_original = VehicleDrivingExt.add_loot
	function VehicleDrivingExt:add_loot(...)
		-- Create a label, if the vehicle has none yet...
		if managers.hud and self._unit:unit_data() and not self._unit:unit_data().name_label_id then
			self._unit:unit_data().name_label_id = managers.hud:add_vehicle_name_label({
				unit = self._unit,
				name = self
					._tweak_data.name
			})
		end

		add_loot_original(self, ...)
	end
end
