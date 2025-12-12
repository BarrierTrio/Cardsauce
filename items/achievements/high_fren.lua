local achInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        local cards = SMODS.find_card('j_csau_frens')
        if cards and #cards > 0 then
            for i, v in ipairs(cards) do
                local faces = 0
                if G.playing_cards then
                    for k, _v in pairs(G.playing_cards) do
                        if _v:is_face() then faces = faces+1 end
                    end
                    return to_big(v.ability.extra.chips_mod * faces) >= to_big(100)
                end
            end
        end
    end,
}

return achInfo