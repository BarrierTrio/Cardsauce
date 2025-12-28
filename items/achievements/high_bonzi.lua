local achInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        local cards = SMODS.find_card('j_csau_bonzi')
        if cards and #cards > 0 then
            for i, v in ipairs(cards) do
                if to_big(v.ability.extra.mult) >= to_big(100) then
                    return true
                end
            end
        end
    end,
}

return achInfo