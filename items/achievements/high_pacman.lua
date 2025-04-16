local trophyInfo = {
    rarity = 1,
    hidden_text = true,
    bypass_all_unlocked = true,
    unlock_condition = function(self, args)
        local cards = SMODS.find_card('j_csau_pacman')
        if cards and #cards > 0 then
            for i, v in ipairs(cards) do
                if v.ability.extra.mult >= 30 then
                    return true
                end
            end
        end
    end,
}

return trophyInfo