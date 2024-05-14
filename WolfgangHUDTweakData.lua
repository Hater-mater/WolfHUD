WolfgangHUDTweakData = WolfgangHUDTweakData or class()
function WolfgangHUDTweakData:init()
	------------------------------------------------------------------------------------------------------------------------------
	-- WolfgangHUD Tweak Data																									--
	------------------------------------------------------------------------------------------------------------------------------
	-- This file enables access to advanced settings, or those I cannot really implement into ingame menus easily.		      	--
	-- If you want to save those changes, please copy this file to "RAID World War II/mods/saves" and edit that copy instead.	--
	-- You will need to take care of that version beeing up to date on your own.												--
	-- It will not get changed on updates automatically.																		--
	-- If you encounter problems, make sure the contents of this file matches the contents of your customized version.			--
	------------------------------------------------------------------------------------------------------------------------------

	-- Determines which messages get logged
	self.LOG_MODE = {
		error = true, -- log errors
		warning = true, -- log warnings
		info = false, -- log infos
	}

	-- Time within 2 presses of the interact button, to enter a turret/flak in stealth.
	self.STEALTH_TURRETS_TIMEOUT = 0.25

	-- Color table
	--		Add or remove any color you want
	--		'color' needs to be that colors hexadecimal code
	--		'name' will be the name it appears in the selection menus
	self.color_table = {
		{ color = 'FFFFFF', name = "white" },
		{ color = 'F2F250', name = "light_yellow" },
		{ color = 'F2C24E', name = "light_orange" },
		{ color = 'E55858', name = "light_red" },
		{ color = 'CC55CC', name = "light_purple" },
		{ color = '00FF00', name = "light_green" },
		{ color = '00FFFF', name = "light_blue" },
		{ color = 'BABABA', name = "light_gray" },
		{ color = 'FFFF00', name = "yellow" },
		{ color = 'FFA500', name = "orange" },
		{ color = 'FF0000', name = "red" },
		{ color = '800080', name = "purple" },
		{ color = '008000', name = "green" },
		{ color = '0000FF', name = "blue" },
		{ color = '808080', name = "gray" },
		{ color = '000000', name = "black" },
		{ color = nil,      name = "rainbow" },
	}
end
