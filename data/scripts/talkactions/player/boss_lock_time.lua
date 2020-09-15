local bossTime = TalkAction("!boss")

local config = {
	{storage = Storage.ForgottenKnowledge.HorrorTimer, s = "Frozen Horror"},
	{storage = Storage.ForgottenKnowledge.LloydTimer, s = "Lloyd"},
	{storage = Storage.ForgottenKnowledge.DragonkingTimer, s = "Dragonking"},
	{storage = Storage.ForgottenKnowledge.LadyTenebrisTimer, s = "Tenebris"},
	{storage = Storage.ForgottenKnowledge.TimeGuardianTimer, s = "Time Guardian"},
	{storage = Storage.ForgottenKnowledge.ThornKnightTimer, s = "Thorn Knight"},
	{storage = Storage.ForgottenKnowledge.LastLoreTimer, s = "Last Lore Guardian"},
}

function etaString(player, boss)
	local t = player:getStorageValue(boss.storage)
	if t == nil then
		return ""
	end
	t = t - os.time()
	if t<0 then
		return boss.s .. ": ready"
	end
	return boss.s .. ": " .. (t >= 24*3600*1000 and (math.floor(t/24/3600/1000) .. " days ") or "")  ..  os.date("!%X",t)
end

function bossTime.onSay(player, words, param)
	local first = false
	local ctime = os.time()
	for i = 1, #config do
		local storage = player:getStorageValue(config[i].storage)
		if storage ~= nil then
			if not first then
				first = true
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Boss locks:")
			end
			--player:sendTextMessage(MESSAGE_EVENT_ADVANCE, config[i].s .. ": " .. (storage>ctime and (math.floor((storage-ctime)/1000/3600/24) .. " days " .. os.date("!%X",storage-ctime) ) or "ready"))
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, etaString(player, config[i]))
		end
	end
	if not first then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"You haven't defeated any bosses yet")
	end
	return false
end

bossTime:separator(" ")
bossTime:register()
