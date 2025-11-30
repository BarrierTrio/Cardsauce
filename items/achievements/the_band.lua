local trophyInfo = {
    rarity = 3,
    unlock_condition = function(self, args)
        if G.jokers and #G.jokers.cards > 0 then
            local jokers = {
                'j_csau_besomeone',
                'j_csau_garbagehand',
                'j_csau_anotherlight',
                'j_csau_kerosene',
                'j_csau_vincenzo',
                'j_csau_quarterdumb'
            }
            return ArrowAPI.game.have_multiple_jokers(jokers, 4)
        end
    end,
}

return trophyInfo