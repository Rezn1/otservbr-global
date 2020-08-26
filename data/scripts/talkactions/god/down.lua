local down = TalkAction("/down")

function down.onSay(player, words, param)
	if not player:getGroup():getAccess() and player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	local position = player:getPosition()
	position.z = position.z + 1
	player:teleportTo(position)
	return false
end

down:separator(" ")
down:register()
