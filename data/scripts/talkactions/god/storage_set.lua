local storageSet = TalkAction("/set")

function storageSet.onSay(cid, words, param)
	local player = Player(cid)
	if not player:getGroup():getAccess() and player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	local split = param:split(",")
	if split[2] == nil then
		player:sendCancelMessage("Insufficient parameters.")
		return false
	end

	local target = Player(split[1])
	if target == nil then
		player:sendCancelMessage("A player with that name is not online.")
		return false
	end

	-- Trim left
	split[2] = split[2]:gsub("^%s*(.-)$", "%1")
	split[3] = split[3]:gsub("^%s*(.-)$", "%1")
	local ch = split[2]
	local ch2 = split[3]
	local storage = tonumber(ch)
	if storage == nil then
		ch = ch:gsub("^Storage.(.-)$", "%1")
		ch = ch:split(".")
		storage = Storage
		for i=1, #ch do
			storage = storage[ch[i]]
			if storage == nil or (type(storage)~="table" and i~=#ch) then
				return false
			end
		end
	end
	setPlayerStorageValue(getPlayerByName(split[1]), storage, tonumber(ch2))
	doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The storage with id: "..storage.." from player "..split[1].." is now: "..ch2..".")
	return false
end

storageSet:separator(" ")
storageSet:register()
