function onCastSpell(creature, var)
	if creature:getCondition(CONDITION_POISON) or creature:getCondition(CONDITION_FIRE) 
	or creature:getCondition(CONDITION_ENERGY) or creature:getCondition(CONDITION_BLEEDING) 
	or creature:getCondition(CONDITION_CURSED) or creature:getCondition(CONDITION_DAZZLED) then
		local pos = creature:getPosition()
		pos.y = pos.y - 1
		Game.createMonster('corrupted soul', pos, true, true)
		creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		return
	end
    return true
end
