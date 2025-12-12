local achInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        local cards = SMODS.find_card('j_csau_facade')
        if cards and #cards > 0 then
            for i, v in ipairs(cards) do
                if G.GAME and G.GAME.hands then
                    if to_big(G.GAME.hands.Pair.played*v.ability.extra) >= to_big(20) then
                        return true
                    end
                end
            end
        end
    end,
}

return achInfo