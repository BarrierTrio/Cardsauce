local deckInfo = {
    name = 'DISC Deck',
    config = {
        vouchers = {
            'v_crystal_ball',
        },
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {localize{type = 'name_text', key = 'v_crystal_ball', set = 'Voucher'}}}
    end,
    unlock_condition = {type = 'win_deck', deck = 'b_green'}
}

function deckInfo.loc_vars(self, info_queue, card)
    if info_queue then
        info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
    end
end

function deckInfo.apply(self, back)
    G.GAME.unlimited_stands = true
    G.GAME.max_stands = G.GAME.modifiers.max_stands or 1
end

return deckInfo