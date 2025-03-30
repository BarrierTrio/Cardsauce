local deckInfo = {
    name = 'Wheel Deck',
    config = {},
    unlocked = false,
    discovered = false,
    config = {
        vouchers = {
            'v_crystal_ball',
        },
    },
    unlock_condition = {type = 'win_deck', deck = 'b_csau_vine'},
}

deckInfo.loc_vars = function(self, info_queue, card)
    if info_queue then
        info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.keku } }
    end
    return {vars = {localize{type = 'name_text', key = 'v_crystal_ball', set = 'Voucher'}}}
end

deckInfo.calculate = function(self, card, context)
    if context.end_of_round and G.GAME.blind.boss and not context.other_card then
        G.E_MANAGER:add_event(Event({
            func = function()
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    local _card = create_card('VHS', G.consumeables, nil, nil, nil, nil, 'c_csau_blackspine', 'car')
                    _card:add_to_deck()
                    G.consumeables:emplace(_card)
                    G.GAME.consumeable_buffer = 0
                end
                return true
            end }))
    end
end

return deckInfo