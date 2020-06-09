function(states, event, ...)
    -- Crutch for not asking bop when WA is closed or you getting online
    if event == "OPTIONS" then
        aura_env.gFirstShot = true
    end
    
    if event == "ASK_BOP" then
        -- Crutch for not asking bop when WA is closed or you getting online
        if aura_env.gFirstShot then 
            aura_env.gFirstShot = false
            return false
        end
        
        if aura_env.isForbearanceActive("player") then
            aura_env.printWithSpamFilter("It's Forbearance debuff on you!", 1)
            return false
        end
        
        local name = aura_env.whisperBOP()
        if name then
            states["player"] = {
                name = "Asked from\n"..WA_ClassColorName(name),
                duration = 5,
                expirationTime = GetTime() + 5,
                progressType = "timed",
                autoHide = true,
                unit = "player",
                show = true,
                changed = true
            }
            aura_env.incrementRequestCount(name)
            return true
        else 
            aura_env.printWithSpamFilter("No BoP available", 1)
            return false
        end
    end
    
    if event == "UNIT_AURA" then 
        local name = select(1, ...)
        if name and name == "player" and aura_env.isBopActive("player") then
            for _, state in pairs(states) do
                state.show = false
                state.changed = true
            end 
        end
    end
    
    if event == "GROUP_ROSTER_UPDATE" then
        aura_env.buildroster()
    end
    
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local sourceName = select(5, ...)
        local spellName = select(13, ...)
        if spellName == aura_env.bopSpellNameR1
        or spellName == aura_env.bopSpellNameR2
        or spellName == aura_env.bopSpellNameR3 then
            aura_env.setCooldown(sourceName, aura_env.bopCooldownSeconds)
            aura_env.incrementRequestCount(sourceName)
        end
    end
    
    if event == "CHAT_MSG_WHISPER" then
        local message, sender, _, _, name = ...
        local cd = aura_env.getCooldownFromMessage(message)
        
        if cd then
            aura_env.setCooldown(name, cd)
            aura_env.decrementRequestCount(name)
            aura_env.gLastReq = nil
            for _, state in pairs(states) do
                state.show = false
                state.changed = true
            end 
        end
    end
    return true
end