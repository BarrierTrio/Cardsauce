local achInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        local cards = SMODS.find_card('j_csau_sotw')
        if cards and #cards > 0 then
            for i, v in ipairs(cards) do
                local stands_obtained = 0
                for k, _v in pairs(G.GAME.consumeable_usage) do if _v.set == 'Stand' then stands_obtained = stands_obtained + 1 end end
                return to_big(1 + (v.ability.extra.x_mult_mod*stands_obtained)) >= to_big(3)
            end
        end
    end,
}

return achInfo