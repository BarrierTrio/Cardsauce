local achInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        local cards = SMODS.find_card('j_csau_april')
        if cards and #cards > 0 then
            for i, v in ipairs(cards) do
                if G.GAME.consumeable_usage and G.GAME.consumeable_usage['c_fool'] then
                    if to_big(G.GAME.consumeable_usage['c_fool'].count) > to_big(0) then
                        return to_big(G.GAME.consumeable_usage['c_fool'].count * v.ability.extra.mult_mod) >= to_big(40)
                    end
                end
            end
        end
    end,
}

return achInfo