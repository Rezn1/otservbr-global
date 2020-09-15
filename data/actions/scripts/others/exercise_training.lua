local skills = {
    [32384] = {id=SKILL_SWORD,voc=4}, -- KNIGHT
    [32385] = {id=SKILL_AXE,voc=4}, -- KNIGHT
    [32386] = {id=SKILL_CLUB,voc=4}, -- KNIGHT
    [32387] = {id=SKILL_DISTANCE,voc=3,range=CONST_ANI_SIMPLEARROW}, -- PALADIN
    [32388] = {id=SKILL_MAGLEVEL,voc=2,range=CONST_ANI_SMALLICE}, -- DRUID
    [32389] = {id=SKILL_MAGLEVEL,voc=1,range=CONST_ANI_FIRE}, -- SORCERER
    [32124] = {id=SKILL_SWORD,voc=4}, -- KNIGHT
    [32125] = {id=SKILL_AXE,voc=4}, -- KNIGHT
    [32126] = {id=SKILL_CLUB,voc=4}, -- KNIGHT
    [32127] = {id=SKILL_DISTANCE,voc=3,range=CONST_ANI_SIMPLEARROW}, -- PALADIN
    [32128] = {id=SKILL_MAGLEVEL,voc=2,range=CONST_ANI_SMALLICE}, -- DRUID
    [32129] = {id=SKILL_MAGLEVEL,voc=1,range=CONST_ANI_FIRE} -- SORCERER
}

local melee = {SKILL_SWORD, SKILL_AXE, SKILL_CLUB}

local houseDummies = {32143, 32144, 32145, 32146, 32147, 32148}
local freeDummies = {32142, 32149}
local skillRate = configManager.getNumber(configKeys.RATE_SKILL)*7
local magicRate = configManager.getNumber(configKeys.RATE_MAGIC)

local function start_train(pid,start_pos,itemid,fpos, bonusDummy, dummyId)
    local player = Player(pid)
    if player ~= nil then
    if Tile(fpos):getItemById(dummyId) then
        local pos_n = player:getPosition()
        if start_pos:getDistance(pos_n) == 0 and getTilePzInfo(pos_n) then
            if player:getItemCount(itemid) >= 1 then
                local exercise = player:getItemById(itemid,true)
                if exercise:isItem() then
                    if exercise:hasAttribute(ITEM_ATTRIBUTE_CHARGES) then
                        local charges_n = exercise:getAttribute(ITEM_ATTRIBUTE_CHARGES)
                        if charges_n >= 1 then
                            exercise:setAttribute(ITEM_ATTRIBUTE_CHARGES,(charges_n-1))

                            local voc = player:getVocation()
							local bonus = bonusDummy and 1 or 1.1
                            if skills[itemid].id == SKILL_MAGLEVEL then
                                player:addManaSpent(math.ceil(500*magicRate)*bonus)
                            else
								if isInArray(melee ,skills[itemid].id) then
									player:addSkillTries(SKILL_SWORD, 1*skillRate*bonus)
									player:addSkillTries(SKILL_AXE, 1*skillRate*bonus)
									player:addSkillTries(SKILL_CLUB, 1*skillRate*bonus)
									player:addSkillTries(SKILL_SHIELD, 1*skillRate*bonus)
								else
									player:addSkillTries(skills[itemid].id, 1*skillRate*bonus)
								end
                            end
                                fpos:sendMagicEffect(CONST_ME_HITAREA)
                            if skills[itemid].range then
                                pos_n:sendDistanceEffect(fpos, skills[itemid].range)
                            end
                            local training = addEvent(start_train, voc:getAttackSpeed(), pid,start_pos,itemid,fpos,bonusDummy,dummyId)
                            player:setStorageValue(Storage.isTraining,1)
                        else
                            exercise:remove(1)
                            player:sendTextMessage(MESSAGE_INFO_DESCR, "Your training weapon vanished.")
							print("\a")
                            stopEvent(training)
                            player:setStorageValue(Storage.isTraining,0)
                        end
                    end
                end
            end
        else
            player:sendTextMessage(MESSAGE_INFO_DESCR, "Your training has stopped.")
            stopEvent(training)
            player:setStorageValue(Storage.isTraining,0)
        end
    else
    stopEvent(training)
            player:sendTextMessage(MESSAGE_INFO_DESCR, "Your training has stopped.")
            player:setStorageValue(Storage.isTraining, 0)
            end
            else
        stopEvent(training)
        if player then
            player:sendTextMessage(MESSAGE_INFO_DESCR, "Your training has stopped.")
            player:setStorageValue(Storage.isTraining,0)
        end
    end
  
    return true
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local start_pos = player:getPosition()
    if player:getStorageValue(Storage.isTraining) == 1 then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You are already training.")
        return false
    end
    if target:isItem() then
        if isInArray(houseDummies,target:getId()) then
            if not skills[item.itemid].range and (start_pos:getDistance(target:getPosition()) > 1) then
                player:sendTextMessage(MESSAGE_INFO_DESCR, "Get closer to the dummy.")
                stopEvent(training)
                return true
            end
            player:sendTextMessage(MESSAGE_INFO_DESCR, "You started training.")
            start_train(player:getId(),start_pos,item.itemid,target:getPosition(), true, target:getId())
        elseif isInArray(freeDummies, target:getId()) then
            if not skills[item.itemid].range and (start_pos:getDistance(target:getPosition()) > 1) then
                player:sendTextMessage(MESSAGE_INFO_DESCR, "Get closer to the dummy.")
                stopEvent(training)
                return true
            end
            player:sendTextMessage(MESSAGE_INFO_DESCR, "You started training.")
            start_train(player:getId(),start_pos,item.itemid,target:getPosition(), false, target:getId())
        end
    end
    return true
end