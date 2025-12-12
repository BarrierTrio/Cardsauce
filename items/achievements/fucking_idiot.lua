local achInfo = {
    rarity = 3,
    unlock_condition = function(self, args)
        if G.jokers and #G.jokers.cards > 0 then
            local jokers1 = {
                'j_csau_powers',
                'j_oops',
            }
            local jokers2 = {
                'j_csau_powers',
                'j_csau_beginners',
            }
            return (ArrowAPI.game.have_multiple_jokers(jokers1) or ArrowAPI.game.have_multiple_jokers(jokers2))
        end
    end,
}

return achInfo