-- All credits for base WeakAura goes to:
-- Buds#0500 @ Discord  - https://wago.io/p/Buds
-- Ask/Give BoP improvement was made by Gordory
-- update: 20/05/2020
--
-- use with this macro:
-- /run WeakAuras.ScanEvents("ASK_BOP")

-- don't edit below

aura_env.bopSpellNameR1 = GetSpellInfo(1022) -- Bop (1 Rank)
aura_env.bopSpellNameR2 = GetSpellInfo(5599) -- Bop (2 Rank)
aura_env.bopSpellNameR3 = GetSpellInfo(10278) -- Bop (3 Rank)

aura_env.bopSpellIdR1 = 1022 -- Bop (1 Rank)
aura_env.bopSpellIdR2 = 5599 -- Bop (2 Rank)
aura_env.bopSpellIdR3 = 10278 -- Bop (3 Rank)

aura_env.bopCooldownSeconds = 180 -- 300s base CD but with Guardian's Favor 180s
aura_env.forbearanceSpellId = 25771

aura_env.paladinClassId = 2

aura_env.gFirstShot = true
aura_env.gLastReq = nil
local gLastMessage

local cooldowns = {} -- [name] = {server, time_lastuse, time_lastreq, count_requests}

aura_env.incrementRequestCount = function(name)
    if name then
        cooldowns[name][4] = cooldowns[name][4] + 1
    end    
end

aura_env.decrementRequestCount = function(name)
    if name then
        cooldowns[name][4] = cooldowns[name][4] - 1
    end
end

aura_env.printWithSpamFilter = function(message, spamFilterSec) 
    local time = GetTime()
    if not gLastMessage or (time - gLastMessage) > spamFilterSec then
        print(message)
        gLastMessage = time
    end
end

aura_env.buildroster = function()
    for unit in WA_IterateGroupMembers() do
        local name, server = UnitName(unit)
        local _, _, classId = UnitClass(unit)
        
        if name and classId
        and classId == aura_env.paladinClassId 
        and not aura_env.isPaladinIgnored(name) then
            if not cooldowns[name] then
                cooldowns[name] = {server, nil, nil, 0}
            end
        end
    end
end

aura_env.isPaladinIgnored = function(name)
    for i, v in ipairs(aura_env.config.paladins) do
        if v and v.name and v.name == name and v.enable then
            return true
        end
    end
    return false
end

aura_env.setCooldown = function(name, cooldown)
    if not name or not cooldown 
    or aura_env.isPaladinIgnored(name) then 
        return 
    end
    
    for paladinName, values in pairs(cooldowns) do
        if paladinName == name and cooldowns[name] then 
            local cooldownEndTime = GetTime() + cooldown
            cooldowns[name][2] = cooldownEndTime
            break
        end
    end
end

aura_env.isForbearanceActive = function(unitId)
    for i=1,40 do
        name,_,_,_,_,_,_,_,_,spellId = UnitDebuff(unitId, i)
        if spellId == aura_env.forbearanceSpellId then
            return true
        end
        return false
    end
end

aura_env.isBopActive = function(unitId)
    for i=1,40 do
        name,_,_,_,_,_,_,_,_,spellId = UnitBuff(unitId, i)
        if spellId == aura_env.bopSpellIdR1
        or spellId == aura_env.bopSpellIdR2
        or spellId == aura_env.bopSpellIdR2 then
            return true
        end
    end
    return false
end

aura_env.whisperBOP = function()
    aura_env.buildroster()
    
    local time = GetTime()
    
    -- spam filter for requests is 2s (reaction time + gcd)
    if not aura_env.gLastReq or (time - aura_env.gLastReq) > 2 then
        local nameToReq = nil
        local minCountReq = nil
        
        for name, values in pairs(cooldowns) do
            if UnitIsConnected(name)
            and UnitIsVisible(name)
            and UnitIsPlayer(name)
            and not UnitIsDeadOrGhost(name) 
            and IsItemInRange(1180, name) -- Scroll of Stamina 30y
            then
                --Magic! If lastUse variable will be named not like this - this will not work
                local server, lastUse, lastReq, countReq = unpack(values)
                
                -- check BoP ready. 2s = 1.5 GCD + 0.5s reaction time
                if not lastUse or (lastUse-time) < 2 then
                    -- check last request > 5s (aura showing time)
                    if not lastReq or (time - lastReq) > 5 then
                        -- if this paladin was never asked
                        if countReq == 0 then
                            nameToReq = name
                            break
                        end
                        
                        if not minCountReq
                        or countReq < minCountReq  then
                            minCountReq = countReq
                            nameToReq = name
                        end
                    end
                end
            end
        end
        
        if nameToReq then 
            SendChatMessage(aura_env.config.word, "WHISPER", nil, nameToReq)
            cooldowns[nameToReq][3] = time
            aura_env.gLastReq = time
        end
        return nameToReq
    end
    return nil
end

aura_env.getCooldownFromMessage = function(message)
    local phrasePrefix = "Sorry, my BoP is on CD for "
    
    if not message then 
        return nil
    end
    
    if not string.find(message, phrasePrefix) then
        return nil
    end
    
    local index,length = string.find(message, phrasePrefix)
    local start = index + length
    index,_ = string.find(message, "secs")
    local cd = string.sub(message, start, index-1)
    return cd
end

aura_env.buildroster()