if string.lower(RequiredScript) == "lib/network/base/basenetworksession" then

	local on_peer_kicked_original = BaseNetworkSession.on_peer_kicked

	function BaseNetworkSession:on_peer_kicked(peer, peer_id, message_id)
		if WolfgangHUD:getSetting({"HOST", "KICK_A_FRIEND"}, true) and Network:is_server() and message_id == 0 and Steam:logged_on() then
			for _, user in ipairs(Steam:friends() or {}) do
				if user:id() == peer:user_id() then
					return on_peer_kicked_original(self, peer, peer_id, 1)
				end
			end
		end
		return on_peer_kicked_original(self, peer, peer_id, message_id)
	end

end