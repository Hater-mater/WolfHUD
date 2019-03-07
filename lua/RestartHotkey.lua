
if not game_state_machine then
	do return end
end
local state = game_state_machine:current_state_name()
if state == "ingame_waiting_for_players" or
		state == "ingame_lobby_menu" or
		state == "empty" then
	do return end
end
local job = managers.raid_job
if not job or job:is_in_tutorial() or job:is_camp_loaded() or not job:current_job() or job:current_job().consumable then
	do return end
end

local callback_handler = RaidMenuCallbackHandler:new()
if Global.game_settings.single_player then
	callback_handler:singleplayer_restart_mission()
elseif Network:is_server() then
	callback_handler:restart_mission()
end
