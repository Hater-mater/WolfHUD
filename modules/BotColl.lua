if string.lower(RequiredScript) == "lib/units/weapons/raycastweaponbase" then

	local init_original = RaycastWeaponBase.init
	local setup_original = RaycastWeaponBase.setup

	function RaycastWeaponBase:init(...)
		init_original(self, ...)
		if WolfgangHUD:getSetting({"GAMEPLAY", "NO_BOT_BULLET_COLL"}, true) then
			self._bullet_slotmask = self._bullet_slotmask - World:make_slot_mask(16)
		end
	end

	function RaycastWeaponBase:setup(...)
		setup_original(self, ...)
		if WolfgangHUD:getSetting({"GAMEPLAY", "NO_BOT_BULLET_COLL"}, true) then
			self._bullet_slotmask = self._bullet_slotmask - World:make_slot_mask(16)
		end
	end

end