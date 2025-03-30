local consumInfo = {
    name = 'Black Spine',
    set = "VHS",
    cost = 3,
    alerted = true,
    nosleeve = true,
    config = {
        unpauseable = true,
    },
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
end

function consumInfo.calculate(self, card, context)
    if context.setting_blind and G.consumeables.config.card_limit > #G.consumeables.cards then
        local e = {config = {ref_table = card}}
        G.E_MANAGER:add_event(Event({func = function()
            G.FUNCS.use_card(e, true)
            return true
        end }))
    end
end

function consumInfo.use(self, card, area, copier)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            local card = create_card('VHS', G.consumeables, nil, nil, nil, nil, nil, 'blackspine')
            card:add_to_deck()
            G.consumeables:emplace(card)
            card:juice_up(0.3, 0.5)
        return true
    end }))
    delay(0.6)
    SMODS.calculate_context({vhs_death = true, card = card})
end

function consumInfo.can_use(self, card)
    return false
end

return consumInfo