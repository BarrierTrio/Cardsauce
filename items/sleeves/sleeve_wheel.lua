local sleeveInfo = {
    name = 'Wheel Sleeve',
    config = {},
    unlocked = false,
    unlock_condition = { deck = "b_csau_wheel", stake = "stake_green" },
    artist = 'Kekulism',
}

sleeveInfo.loc_vars = function(self, info_queue)
    local key = self.key
    self.config = { voucher = 'v_crystal_ball' }

    if self.get_current_deck_key() == "b_csau_wheel" then
        key = key .. "_alt"
        self.config.voucher = "v_csau_scavenger"
    end

    local vars = { localize{type = 'name_text', key = self.config.voucher, set = 'Voucher'} }
    return { key = key, vars = vars }
end

sleeveInfo.calculate = function(self, card, context)
    if context.end_of_round and G.GAME.blind.boss and not context.other_card then
        if self.get_current_deck_key() ~= "b_csau_wheel" then
            G.E_MANAGER:add_event(Event({
                func = function()
                    if to_big(#G.consumeables.cards + G.GAME.consumeable_buffer) < to_big(G.consumeables.config.card_limit) then
                        local _card = create_card('VHS', G.consumeables, nil, nil, nil, nil, 'c_csau_blackspine', 'car')
                        _card:add_to_deck()
                        G.consumeables:emplace(_card)
                        G.GAME.consumeable_buffer = 0
                    end
                    return true
                end }))
        end
    end
end

sleeveInfo.apply = function(self, sleeve)
    CardSleeves.Sleeve.apply(sleeve)
end

return sleeveInfo