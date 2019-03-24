
local print_debug = function(text, ...)
	text = string.format("(GameInfo) %s", tostring(text))
	WolfgangHUD:print_log(text, ...)
end

if string.lower(RequiredScript) == "lib/setups/setup" then

	local init_managers_original = Setup.init_managers

	function Setup:init_managers(managers, ...)
		managers.gameinfo = managers.gameinfo or GameInfoManager:new()
		return init_managers_original(self, managers, ...)
	end

	GameInfoManager = GameInfoManager or class()

	function GameInfoManager:init()
		self._t = 0
		self._scheduled_callbacks = {}
		self._listeners = {}

		self._units = {}
		self._unit_count = {}
	end

	function GameInfoManager:event(source, ...)
		local target = "_" .. source .. "_event"

		if self[target] then
			self[target](self, ...)
		else
			print_debug("No event handler for %s", target, "error")
		end
	end

	function GameInfoManager:register_listener(listener_id, source_type, event, clbk, keys, data_only)
		local listener_keys

		if keys then
			listener_keys = {}
			for _, key in ipairs(keys) do
				listener_keys[key] = true
			end
		end

		self._listeners[source_type] = self._listeners[source_type] or {}
		self._listeners[source_type][event] = self._listeners[source_type][event] or {}
		self._listeners[source_type][event][listener_id] = {clbk = clbk, keys = listener_keys, data_only = data_only}
	end

	function GameInfoManager:unregister_listener(listener_id, source_type, event)
		if self._listeners[source_type] then
			if self._listeners[source_type][event] then
				self._listeners[source_type][event][listener_id] = nil
			end
		end
	end

	function GameInfoManager:_listener_callback(source, event, key, ...)
		for listener_id, data in pairs(self._listeners[source] and self._listeners[source][event] or {}) do
			if not data.keys or data.keys[key] then
				if data.data_only then
					data.clbk(...)
				else
					data.clbk(event, key, ...)
				end
			end
		end
	end

	-- UNIT

	function GameInfoManager:_unit_event(event, key, data)
		if event == "add" then
			if not self._units[key] then
				local unit_type = data.unit:base()._tweak_table
				self._units[key] = {unit = data.unit, type = unit_type}
				self:_listener_callback("unit", event, key, self._units[key])
				self:_unit_count_event("change", unit_type, 1)
			end
		elseif event == "remove" then
			if self._units[key] then
				self:_listener_callback("unit", event, key, self._units[key])
				self:_unit_count_event("change", self._units[key].type, -1)
				self._units[key] = nil
			end
		end
	end

	function GameInfoManager:_unit_count_event(event, unit_type, value)
		if event == "change" then
			if value ~= 0 then
				self._unit_count[unit_type] = (self._unit_count[unit_type] or 0) + value
				self:_listener_callback("unit_count", "change", unit_type, value)
			end
		elseif event == "set" then
			self:_unit_count_event("change", unit_type, value - (self._unit_count[unit_type] or 0))
		end
	end

	function GameInfoManager:get_units(key)
		if key then
			return self._units[key]
		else
			return self._units
		end
	end

	function GameInfoManager:get_unit_count(id)
		if id then
			return self._unit_count[id] or 0
		else
			return self._unit_count
		end
	end

elseif string.lower(RequiredScript) == "lib/managers/enemymanager" then

	local on_enemy_registered_original = EnemyManager.on_enemy_registered
	local on_enemy_unregistered_original = EnemyManager.on_enemy_unregistered

	function EnemyManager:on_enemy_registered(unit, ...)
		managers.gameinfo:event("unit", "add", tostring(unit:key()), {unit = unit})
		on_enemy_registered_original(self, unit, ...)
	end

	function EnemyManager:on_enemy_unregistered(unit, ...)
		managers.gameinfo:event("unit", "remove", tostring(unit:key()))
		on_enemy_unregistered_original(self, unit, ...)
	end

end
