if string.lower(RequiredScript) == "lib/states/eventcompletestate" then

	local is_skipped_original = EventCompleteState.is_skipped

	function EventCompleteState:is_skipped(...)
		return WolfgangHUD and WolfgangHUD:getSetting({"MENU", "NO_DEBRIEFING"}, false) or is_skipped_original(self, ...)
	end

end