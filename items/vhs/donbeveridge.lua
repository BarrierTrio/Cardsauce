local consumInfo = {
    name = 'Don Beveridge Customerization Seminar',
    key = 'donbeveridge',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        unpauseable = true,
    },
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
end

function consumInfo.calculate(self, card, context)
    if context.setting_blind and G.jokers.config.card_limit > #G.jokers.cards then
        local e = {config = {ref_table = card}}
        G.E_MANAGER:add_event(Event({func = function()
            G.FUNCS.use_card(e, true)
            return true
        end }))
    end
end

function consumInfo.use(self, card, context)
    local food_options = {}
    for k,v in pairs (G.foodjokers) do food_options[#food_options+1] = k end
    local rand_food
    repeat
        rand_food = pseudorandom_element(food_options, pseudoseed('WEGOTBAGELS'))
    until (rand_food == 'j_cavendish' and G.GAME.pool_flags.gros_michel_extinct) or rand_food ~= 'j_cavendish'
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
        play_sound('timpani')
        local card = create_card('Joker', G.jokers, nil, nil, nil, nil, rand_food, 'PUSHTHEWHOPPERBUTTON')
        card:add_to_deck()
        G.jokers:emplace(card)
        card:juice_up(0.3, 0.5)
        return true end }))
    delay(0.6)
    SMODS.calculate_context({vhs_death = true, card = card})
end

function consumInfo.can_use(self, card)
    return false
end

return consumInfo