local consumInfo = {
    name = 'Twisted Pair',
    key = 'twistedpair',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        extra = {
            runtime = 2,
            uses = 0,
        },
        activated = false,
        destroy = false,
    },
    artist = 'FenixSeraph'
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    return { vars = { card.ability.extra.runtime-card.ability.extra.uses } }
end

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.before and not card.debuff and not context.blueprint then
        G.E_MANAGER:add_event(Event({
            func = function()
                local _card = copy_card(context.scoring_hand[1])
                _card:start_materialize({G.C.SECONDARY_SET.Enhanced})
                G.hand:emplace(_card)
                table.insert(G.playing_cards, _card)
                playing_card_joker_effects({_card})
                card:juice_up()
                card.ability.extra.uses = card.ability.extra.uses+1
                if to_big(card.ability.extra.uses) >= to_big(card.ability.extra.runtime) then
                    G.FUNCS.destroy_tape(card)
                    card.ability.destroyed = true
                end
                return true
            end}))
    end
end

function consumInfo.can_use(self, card)
    if to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit) or card.area == G.consumeables then return true end
end

return consumInfo