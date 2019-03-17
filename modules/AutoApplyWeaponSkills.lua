do return end -- disabled for now

if string.lower(RequiredScript) == "lib/managers/statisticsmanager" then

	local shot_fired_original = StatisticsManager.shot_fired

	function StatisticsManager:shot_fired(data, ...)
		-- workaround: seems like some dead weapons still send data to the stats manager,
		-- i guess thats happening since we simply replace weapons on the fly, and have no proper garbage collection of some sort,
		-- so whenever a dead unit still sends events, lets catch it here.
		if data ~= nil and type(data) == "table" and data.weapon_unit ~= nil then
			if not alive(data.weapon_unit) then
				return
			end
			WolfgangHUD:print_log(tostring(data.weapon_unit), "info")
		end
		shot_fired_original(self, data, ...)
	end

elseif string.lower(RequiredScript) == "lib/managers/weaponskillsmanager" then

	local on_weapon_challenge_completed_original = WeaponSkillsManager.on_weapon_challenge_completed

	function WeaponSkillsManager:on_weapon_challenge_completed(weapon_id, tier_index, skill_index)

		if managers.achievment and managers.challenge and managers.statistics and managers.upgrades and managers.blackmarket and managers.player and managers.hud and
				WolfgangHUD:getSetting({"GAMEPLAY", "AUTO_APPLY_WEAPON_SKILLS"}, true) then

			local is_secondary = false
			for index, weapon_data in pairs(tweak_data.weapon_inventory.weapon_secondaries_index) do
				if weapon_data.weapon_id == weapon_id then
					is_secondary = true
				end
			end
			local weapon_category_id = is_secondary and WeaponInventoryManager.BM_CATEGORY_SECONDARY_ID or WeaponInventoryManager.BM_CATEGORY_PRIMARY_ID
			local weapon_category = is_secondary and WeaponInventoryManager.BM_CATEGORY_SECONDARY_NAME or WeaponInventoryManager.BM_CATEGORY_PRIMARY_NAME

			-- apply skill, unlock next tier, trigger achievments
			self:activate_skill(Global.weapon_skills_manager.weapon_skills_skill_tree[weapon_id][tier_index][skill_index][1], weapon_category_id)

			-- trigger statistics
			if tier_index >= 4 then
				managers.statistics:tier_4_weapon_skill_bought(weapon_id)
			end

			-- reload challenges
			self:deactivate_challenges_for_weapon(weapon_id)
			self:activate_current_challenges_for_weapon(weapon_id)

			-- reload skills
			self:update_weapon_skills(weapon_category_id, weapon_id, "activate")

			-- send new data
			managers.player:sync_upgrades()

			-- store current ammo values
			local player = managers.player:local_player()
			local player_state = player:movement():current_state()
			local weapon_base = player_state._equipped_unit:base()
			local ammo_total = weapon_base:get_ammo_total()
			local ammo_remaining_in_clip = weapon_base:get_ammo_remaining_in_clip()

			-- recreate blueprint
			self:recreate_weapon_blueprint(weapon_id, weapon_category_id, nil, true)

			-- load recreated blueprint
			local weapon_slot = managers.blackmarket:equipped_weapon_slot(weapon_category)
			local weapon_data = is_secondary and managers.blackmarket:equipped_secondary() or managers.blackmarket:equipped_primary()
			local texture_switches = managers.blackmarket:get_weapon_texture_switches(weapon_category, weapon_slot, weapon_data)

			-- respawn weapon with new blueprint (this sets ammo to max, and refreshes the hud)
			local inventory = player:inventory()
			inventory:add_unit_by_factory_name(weapon_data.factory_id, true, false, weapon_data.blueprint, weapon_data.cosmetics, texture_switches)
			inventory:equip_selection(weapon_category_id, true)

			player_state._equipped_unit = inventory:equipped_unit()
			local weapon = inventory:equipped_unit()
			player_state._weapon_hold = weapon and weapon:base().weapon_hold and weapon:base():weapon_hold() or weapon:base():get_name_id()
			player_state:inventory_clbk_listener(player, "equip")

			-- send new data
			inventory:_send_equipped_weapon()

			-- restore previous ammo values
			weapon_base = weapon:base() -- reload
			weapon_base:set_ammo_total(ammo_total)
			weapon_base:set_ammo_remaining_in_clip(ammo_remaining_in_clip)

			-- refresh hud again
			managers.hud:set_ammo_amount(weapon_base:selection_index(), weapon_base:ammo_info())

		end

		-- popup notification, play sound, add category breadcrumb, save game
		on_weapon_challenge_completed_original(self, weapon_id, tier_index, skill_index)

	end

end