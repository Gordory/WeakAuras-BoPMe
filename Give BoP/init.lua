aura_env.bopSpellNameR1 = GetSpellInfo(1022) -- Bop (1 Rank)
aura_env.bopSpellNameR2 = GetSpellInfo(5599) -- Bop (2 Rank)
aura_env.bopSpellNameR3 = GetSpellInfo(10278) -- Bop (3 Rank)

aura_env.bopSpellIdR1 = 1022 -- Bop (1 Rank)
aura_env.bopSpellIdR2 = 5599 -- Bop (2 Rank)
aura_env.bopSpellIdR3 = 10278 -- Bop (3 Rank)

aura_env.selectCurrentLevelBopId = function()
    if IsSpellKnown(aura_env.bopSpellIdR3, false) then --BoP Rank 1
        return aura_env.bopSpellIdR3
    elseif IsSpellKnown(aura_env.bopSpellIdR2,false) then --BoP Rank 2
        return aura_env.bopSpellIdR2 
    elseif IsSpellKnown(aura_env.bopSpellIdR1,false) then --BoP Rank 3
        return aura_env.bopSpellIdR1
    end 
    return nil;
end

-- Не удаляйте этот комментарий, он является частью этого триггера: Give BoP