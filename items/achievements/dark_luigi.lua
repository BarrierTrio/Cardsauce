local achInfo = {
    rarity = 2,
    unlock_condition = function(self, args)
        if G.jokers and #G.jokers.cards > 0 then
            local cards = SMODS.find_card('j_csau_supper')
            if cards and #cards > 0 then
                for i, v in ipairs(cards) do
                    if v.edition and v.edition.type == 'negative' then
                        return true
                    end
                end
            end
        end
    end,
}

return achInfo