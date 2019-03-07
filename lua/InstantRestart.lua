if string.lower(RequiredScript) == "lib/tweak_data/tweakdata" then

	if tweak_data then
		if Network:is_server() and WolfgangHUD:getSetting({"RESTART", "INSTANT_RESTART"}, true) then
			tweak_data.voting = tweak_data.voting or {}
			tweak_data.voting.restart_delay = 0
		end
	end

end