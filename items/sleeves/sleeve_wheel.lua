local sleeveInfo = {
    name = 'Wheel Sleeve',
    config = {},
    unlocked = false,
    unlock_condition = { deck = "b_csau_wheel", stake = "stake_green" },
    dependencies = {
        config = {
            ['VHSs'] = true,
        }
    },
    artist = 'Kekulism',
}

function sleeveInfo.loc_vars(self, info_queue)
    local matching_deck = self.get_current_deck_key() == "b_csau_wheel"

    return {
        key = self.key..(matching_deck and '_alt' or ''),
        vars = {
            localize({
                type = 'name_text',
                key =  matching_deck and 'v_csau_scavenger' or 'v_crystal_ball',
                set = 'Voucher'
            })
        }
    }
end

function sleeveInfo.apply(self, sleeve)
    if self.get_current_deck_key() == "b_csau_wheel" then
        self.config.voucher = 'v_csau_scavenger'
    else
        self.config.voucher = 'v_crystal_ball'
    end

    CardSleeves.Sleeve.apply(sleeve)
end


sleeveInfo.calculate = function(self, card, context)
    if context.end_of_round and context.main_eval and to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit)
    and G.GAME.blind:get_type() == 'Boss' and self.get_current_deck_key() ~= "b_csau_wheel" then
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                local _card = create_card('VHS', G.consumeables, nil, nil, nil, nil, 'c_csau_blackspine', 'csau_wheel_sleeve')
                _card:add_to_deck()
                G.consumeables:emplace(_card)
                G.GAME.consumeable_buffer = 0
                return true
            end
        }))
    end
end

return sleeveInfo