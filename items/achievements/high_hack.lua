local achInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        local cards = SMODS.find_card('j_csau_hack')
        if cards and #cards > 0 then
            local mod = 1
            if G.GAME and G.GAME.used_vouchers.v_directors_cut then mod = 2 end
            local vhs_obtained = 0
            for k, v in pairs(G.GAME.consumeable_usage) do if v.set == 'VHS' then vhs_obtained = vhs_obtained + 1 end end
            for i, v in ipairs(cards) do
                return to_big((v.ability.extra.chip_mod * vhs_obtained) * mod) >= to_big(200)
            end
        end
    end,
}

return achInfo