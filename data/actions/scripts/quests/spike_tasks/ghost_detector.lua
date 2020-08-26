if not GHOST_DETECTOR_MAP then
	GHOST_DETECTOR_MAP = {}
end

--ghost_detector_area = {
--	from = Position(32008, 32522, 8),
--	to = Position(32365, 32759, 10)
--}
-- Changed. See: data/lib/core/position.lua

ghost_detector_area = {	--n
	{x = 32201, y = 32531, z = 8},
	{x = 32280, y = 32544, z = 8},
	{x = 32304, y = 32631, z = 8},
	{x = 32183, y = 32644, z = 8},
	{x = 32158, y = 32672, z = 9},
	{x = 32187, y = 32538, z = 9},
	{x = 32269, y = 32571, z = 9},
	{x = 32306, y = 32643, z = 9},
	{x = 32242, y = 32656, z = 10},
	{x = 32128, y = 32713, z = 10},
	{x = 32211, y = 32577, z = 10},
	{x = 32306, y = 32584, z = 10},
}

local function getSearchString(fromPos, toPos)
	local distance = 0
	local direction = 0
	local level = 0

	local dx = fromPos.x - toPos.x
	local dy = fromPos.y - toPos.y
	local dz = fromPos.z - toPos.z

	level = (dz > 0) and 0 or (dz < 0) and 1 or 2

	if math.abs(dx) < 5 and math.abs(dy) < 5 then
		distance = 0
	else
		local tmp = dx * dx + dy * dy
		distance = (tmp < 10000) and 1 or (tmp < 75625) and 2 or 3
	end

	local tang = (dx ~= 0) and dy / dx or 10
	if math.abs(tang) < 0.4142 then
		direction = (dx > 0) and 3 or 2
	elseif math.abs(tang) < 2.4142 then
		direction = (tang > 0) and ((dy > 0) and 5 or 6) or ((dx > 0) and 7 or 4)
	else
		direction = (dy > 0) and 0 or 1
	end

	local text = {
		[0] = {
			[0] = "above you",
			[1] = "below you",
			[2] = "next to you"
		},
		[1] = {
			[0] = "on a higher level to the ",
			[1] = "on a lower level to the ",
			[2] = "to the "
		},
		[2] = "far to the ",
		[3] = "very far to the "
	}

	local dirs = {
		[0] = "north",
		[1] = "south",
		[2] = "east",
		[3] = "west",
		[4] = "north-east",
		[5] = "north-west",
		[6] = "south-east",
		[7] = "south-west"
	}

	return ((type(text[distance]) == "table") and text[distance][level] or text[distance]) .. ((distance ~= 0) and dirs[direction] or '')
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local stat = player:getStorageValue(SPIKE_UPPER_TRACK_MAIN)

	if isInArray({-1, 3}, stat) then
		return player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	end

	local current = GHOST_DETECTOR_MAP[player:getGuid()]
	if not current then
		local random = Position.getFreeSand()
		GHOST_DETECTOR_MAP[player:getGuid()] = random
		current = random
	end

	if player:getPosition():compare(current) then
		if stat == 2 then
			item:remove()
			GHOST_DETECTOR_MAP[player:getGuid()] = nil
			player:sendTextMessage(MESSAGE_INFO_DESCR, "Report the task to Gnomilly.")
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You found a malignant presence, the glowing detector signals that it does not need any further data.")
		else
			GHOST_DETECTOR_MAP[player:getGuid()] = getFreeSand()
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You found a malignant presence, the glowing detector signals another presence nearby.')
		end
		player:setStorageValue(SPIKE_UPPER_TRACK_MAIN, stat+1)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The detector points ' .. getSearchString(player:getPosition(), current) .. '.')
	end
	return true
end
