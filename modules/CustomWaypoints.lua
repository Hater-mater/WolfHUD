if string.lower(RequiredScript) == "lib/managers/hudmanagerpd2" then
	local init_original = HUDManager.init

	HUDManager.CUSTOM_WAYPOINTS = {
		DEBUGGING = false,
		PICKUPS = {
			ICON_MAP = {

				-- VALUABLES
				consumable_mission =				{texture = "ui/atlas/raid_atlas_hud", texture_rect = {963, 175, 56, 56}}, -- untested
				regular_cache_box =					{texture = "ui/atlas/raid_atlas_hud", texture_rect = {677, 1317, 32, 32}},
				hold_take_loot =					{texture = "ui/atlas/raid_atlas_missions", texture_rect = {8, 68, 64, 64}},
				hold_take_dogtags =					{texture = "ui/atlas/raid_atlas_missions", texture_rect = {398, 2, 64, 64}},

				-- EQUIPMENT
				take_sps_briefcase =				{std_icon = "equipment_panel_sps_briefcase"}, -- untested
				--take_code_book =					{std_icon = "equipment_panel_code_book"},
				gen_pku_crowbar =					{std_icon = "equipment_panel_crowbar"}, -- FIXME: not working in all raids for some reason
				--dynamite_x1_pku =					{std_icon = "equipment_panel_dynamite_stick"},
				--dynamite_x4_pku =					{std_icon = "equipment_panel_dynamite_stick"},
				--dynamite_x5_pku =					{std_icon = "equipment_panel_dynamite_stick"},
				--take_dynamite_bag =				{std_icon = "equipment_panel_dynamite"},
				hold_take_canister =				{std_icon = "equipment_panel_fuel_full"},
				take_enigma =						{std_icon = "equipment_panel_code_device"}, -- untested
				hold_take_gas_can =					{std_icon = "equipment_panel_fuel_full"}, -- untested
				take_gas_tank =						{std_icon = "equipment_panel_fuel_full"}, -- untested
				mine_pku =							{std_icon = "equipment_panel_cvy_landimine"}, -- untested
				take_portable_radio =				{std_icon = "equipment_panel_recording_device"}, -- untested
				take_tools =						{std_icon = "equipment_panel_tools"},
				take_safe_key =						{std_icon = "equipment_panel_sto_safe_key"}, -- untested
				take_safe_keychain =				{std_icon = "equipment_panel_sto_safe_key"}, -- untested
				take_tank_grenade =					{std_icon = "equipment_panel_dynamite"}, -- untested
				take_tank_shell =					{std_icon = "equipment_panel_tools"}, -- untested
				take_thermite =						{std_icon = "equipment_panel_cvy_thermite"}, -- untested
				gen_pku_thermite =					{std_icon = "equipment_panel_cvy_thermite"}, -- untested
				hold_pku_intelligence =				{texture = "ui/atlas/raid_atlas_hud", texture_rect = {963, 175, 56, 56}}, -- FIXME: did not work in Strongpoint, needs further testing

				-- PICKUPS
				--health_bag =						{std_icon = ""},
				--health_bag_big =					{std_icon = ""},
				--health_bag_small =				{std_icon = ""},
				--ammo_bag =						{std_icon = ""},
				--ammo_bag_big =					{std_icon = ""},
				--ammo_bag_small =					{std_icon = ""},
				--grenade_crate =					{std_icon = ""},
				--grenade_crate_big =				{std_icon = ""},
				--grenade_crate_small =				{std_icon = ""},

				-- FLARES
				--extinguish_flare =				{texture = "ui/atlas/raid_atlas_skills", texture_rect = {2, 152, 76, 76}},

			},
		}
	}

	function HUDManager:init(...)
		init_original(self, ...)

		self:setup_custom_waypoints()
	end

	function HUDManager:setup_custom_waypoints()
		if managers.gameinfo and managers.waypoints then
			if WolfgangHUD:getSetting({"CustomWaypoints", "LOOT", "SHOW"}, true) then
				managers.gameinfo:register_listener("loot_waypoint_listener", "loot", "add", callback(self, self, "custom_waypoint_loot_clbk"))
				managers.gameinfo:register_listener("loot_waypoint_listener", "loot", "remove", callback(self, self, "custom_waypoint_loot_clbk"))
				managers.gameinfo:register_listener("loot_waypoint_listener", "loot", "interact", callback(self, self, "custom_waypoint_loot_clbk"))
			end

			if WolfgangHUD:getSetting({"CustomWaypoints", "SHOW_PICKUPS"}, true) then
				managers.gameinfo:register_listener("equipment_waypoint_listener", "pickup", "add", callback(self, self, "custom_waypoint_pickup_clbk"))
				managers.gameinfo:register_listener("equipment_waypoint_listener", "pickup", "remove", callback(self, self, "custom_waypoint_pickup_clbk"))
			end
		end
	end

	function HUDManager:custom_waypoint_loot_clbk(event, key, data)
		local id = "loot_wp_" .. key
		local tweak_entry = data.carry_id and tweak_data.carry[data.carry_id]

		if event == "add" then
			if tweak_entry and not tweak_entry.is_vehicle and not tweak_entry.skip_exit_secure and (not string.ends(data.carry_id, "_body")) then
				local angle = HUDManager.CUSTOM_WAYPOINTS.DEBUGGING and 180 or WolfgangHUD:getSetting({"CustomWaypoints", "LOOT", "ANGLE"}, 15)
				local name_id = data.carry_id and tweak_data.carry[data.carry_id] and tweak_data.carry[data.carry_id].name_id
				local bag_name = name_id and managers.localization:to_upper_text(name_id)
				local count = data.count or 1
				if bag_name then
					local params = {
						unit = data.unit,
						offset = Vector3(0, 0, WolfgangHUD:getSetting({"CustomWaypoints", "LOOT", "OFFSET"}, 15)),
						visible_through_walls = HUDManager.CUSTOM_WAYPOINTS.DEBUGGING,
						alpha = HUDManager.CUSTOM_WAYPOINTS.DEBUGGING and 1 or 0.1,
						visible_angle = {max = angle},
						visible_distance = {max = HUDManager.CUSTOM_WAYPOINTS.DEBUGGING and 99999 or 2000},
						fade_angle = {start_angle = angle, end_angle = angle - 5, final_scale = 8},
						scale = 1.5,
						icon = {
							type = "icon",
							show = WolfgangHUD:getSetting({"CustomWaypoints", "LOOT", "ICON"}, false),
							texture = "ui/ingame/textures/hud/hud_waypoint_icons_01",
							texture_rect = {96, 0, 32, 32},
							alpha = 0.5,
							color = Color.white,
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
							show = HUDManager.CUSTOM_WAYPOINTS.DEBUGGING,
							text = string.format("Editor ID: %s", (data.unit:editor_id() or "N/A")),
						},
						component_order = {{"icon", "amount", "label"}, {"debug_txt"}},
					}

					managers.waypoints:add_waypoint(id, "CustomWaypoint", params)
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

	function HUDManager:custom_waypoint_pickup_clbk(event, key, data)
		local id = "equipment_wp_" .. key

		if event == "add" then
			local icon_table = HUDManager.CUSTOM_WAYPOINTS.PICKUPS.ICON_MAP
			local icon_data = icon_table[data.interact_id]
			if icon_data then
				local params = {
					unit = data.unit,
					offset = icon_data.offset or Vector3(0, 0, 15),
					hide_on_uninteractable = true,
					visible_through_walls = HUDManager.CUSTOM_WAYPOINTS.DEBUGGING or icon_data.x_ray or false,
					scale = 1.25,
					alpha = HUDManager.CUSTOM_WAYPOINTS.DEBUGGING and 1 or 0.1,
					fade_angle = {start_angle = 35, end_angle = 25, final_scale = 8},
					visible_angle = {max = HUDManager.CUSTOM_WAYPOINTS.DEBUGGING and 180 or 35},
					visible_distance = {max = HUDManager.CUSTOM_WAYPOINTS.DEBUGGING and 99999 or 3000},
					color = icon_data.color,
					icon = {
						type = "icon",
						show = true,
						std_wp = icon_data.std_icon,
						texture = icon_data.texture,
						texture_rect = icon_data.texture_rect,
					},
					component_order = {{"icon"}},
				}

				managers.waypoints:add_waypoint(id, "CustomWaypoint", params)
			end
		elseif event == "remove" then
			managers.waypoints:remove_waypoint(id)
		end
	end

end

if string.lower(RequiredScript) == "lib/units/vehicles/vehicledrivingext" then

	local add_loot_original = VehicleDrivingExt.add_loot
	function VehicleDrivingExt:add_loot(...)
		-- Create a label, if the vehicle has none yet...
		if managers.hud and self._unit:unit_data() and not self._unit:unit_data().name_label_id then
			self._unit:unit_data().name_label_id = managers.hud:add_vehicle_name_label({unit = self._unit, name = self._tweak_data.name})
		end

		add_loot_original(self, ...)
	end
end
