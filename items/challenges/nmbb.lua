local chalInfo = {
    rules = {
        custom = {
            {id = "csau_nmbb", }
        },
        modifiers = {
            {id = 'hand_size', value = 5},
        }
    },
    jokers = {
        { id = 'j_csau_blackjack', eternal = true}
    },
    restrictions = {
        banned_other = {
            { id = 'bl_csau_mochamike', type = 'blind'}
        }
    },
    unlocked = function(self)
        return (G.P_CENTERS['j_csau_blackjack'] or {}).discovered
    end
}

return chalInfo