if string.lower(RequiredScript) == "lib/units/interactions/interactionext" then
    local interact_start_original = BaseInteractionExt.interact_start
    local health_pickup_interact_blocked_original = HealthPickupInteractionExt._interact_blocked

    BaseInteractionExt.STEALTH_TURRETS_TIMEOUT = WolfgangHUD:getTweakEntry("STEALTH_TURRETS_TIMEOUT", "number", 0.25) --Timeout for 2 InteractKey pushes, to prevent accidents in stealth

    local TURRET_INTERACTIONS = {
        turret_m2 = true,
        turret_flak_88 = true,
        turret_flakvierling = true,
    }

    function BaseInteractionExt:interact_start(player, locator, ...)
        local t = Application:time()
        if WolfgangHUD:getSetting({ "GAMEPLAY", "INTERACTION", "TURRETS_STEALTH_DISABLED" }, true)
            and managers.groupai:state():whisper_mode()
            and self.tweak_data and table.has(TURRET_INTERACTIONS, self.tweak_data)
            and (t - (self._last_turret_interact_t or 0) >= BaseInteractionExt.STEALTH_TURRETS_TIMEOUT) then
            self._last_turret_interact_t = t
            return false
        end
        return interact_start_original(self, player, locator, ...)
    end

    function HealthPickupInteractionExt:_interact_blocked(player, ...)
        if self.tweak_data == "health_bag_big" then
            local player_damage = player:character_damage()
            if player_damage:get_revives() == (player_damage._class_tweak_data.damage.BASE_LIVES + managers.player:upgrade_value("player", "additional_lives", 0)) then
                -- disallow when maximum revives, with custom hint
                if WolfgangHUD:getSetting({ "GAMEPLAY", "INTERACTION", "REVIVE_BLOCK_MAX_REVIVES" }, true) then
                    self._tweak_data.blocked_hint = "wolfganghud_hint_maximum_revives"
                    return true
                end
            else
                -- allow when below maximum revives, even if full health
                if WolfgangHUD:getSetting({ "GAMEPLAY", "INTERACTION", "REVIVE_ALLOW_FULL_HEALTH" }, true) then
                    return false
                end
            end
        end
        return health_pickup_interact_blocked_original(self, player, ...)
    end
end
