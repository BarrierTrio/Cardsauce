local deckInfo = {
    name = 'Wheel Deck',
    unlocked = false,
    discovered = false,
    config = {
        unlock = 20,
        vouchers = {
            'v_crystal_ball',
        },
    },
    dependencies = {
        config = {
            ['VHSs'] = true,
        }
    },
    artist = 'Kekulism',
}

function deckInfo.loc_vars(self, info_queue, card)
    return {vars = {localize{type = 'name_text', key = 'v_crystal_ball', set = 'Voucher'}}}
end

function deckInfo.locked_loc_vars(self, info_queue, card)
    return { vars = { self.config.unlock, G.DISCOVER_TALLIES.vhss.tally } }
end

function deckInfo.check_for_unlock(self, args)
    return args.type == 'discover_amount' and (to_big(G.DISCOVER_TALLIES.vhss.tally) >= to_big(self.config.unlock))
end

function deckInfo.calculate(self, card, context)
    if context.end_of_round and context.main_eval and to_big(#G.consumeables.cards + G.GAME.consumeable_buffer) < to_big(G.consumeables.config.card_limit)
    and G.GAME.blind:get_type() == 'Boss' and self.get_current_deck_key() ~= "b_csau_wheel" then
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        G.E_MANAGER:add_event(Event({
            func = function()
                local _card = create_card('VHS', G.consumeables, nil, nil, nil, nil, 'c_csau_blackspine', 'csau_wheel_deck')
                _card:add_to_deck()
                G.consumeables:emplace(_card)
                G.GAME.consumeable_buffer = 0
                return true
            end
        }))
    end
end

deckInfo.quip_filter = function(quip)
    return (quip and quip.csau_streamer and quip.csau_streamer == 'vinny')
end

return deckInfo