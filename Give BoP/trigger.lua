function(states, event, ...)
    if event == "CHAT_MSG_WHISPER" then
        local message, sender, _, _, name = ...
        
        if name then
            name = string.gsub(name, "-.*", "")
            message = string.lower(message)
            if message:find(aura_env.config.word1:lower())
            or message:find(aura_env.config.word2:lower())
            or message:find(aura_env.config.word3:lower())
            or message:find(aura_env.config.word4:lower())
            then
                for member in WA_IterateGroupMembers() do
                    if UnitName(member) == name then
                        local currentLevelBopId = aura_env.selectCurrentLevelBopId()
                        if currentLevelBopId then
                            local start, duration = GetSpellCooldown(currentLevelBopId)
                            local expires = Round(start + duration - GetTime())
                            if expires > 2 then
                                SendChatMessage("Sorry, my BoP is on CD for ".. expires .. "secs", "WHISPER", nil, sender)
                            else
                                states[name] = {
                                    name = "BoP on\n"..WA_ClassColorName(member),
                                    duration = 5,
                                    expirationTime = GetTime() + 5,
                                    progressType = "timed",
                                    autoHide = true,
                                    unit = member,
                                    show = true,
                                    changed = true
                                }
                            end
                        end                        
                        break
                    end
                end
            end
        end
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        local unit, _, spellId = ...
        local currentLevelBopId = aura_env.selectCurrentLevelBopId()
        if unit == "player" and currentLevelBopId and spellId == currentLevelBopId then
            for _, state in pairs(states) do
                state.show = false
                state.changed = true
            end            
        end
    end
    return true
end