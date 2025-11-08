local consumInfo = {
    name = 'Blood Debts',
    key = 'blooddebts',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        activated = false,
        destroyed = false,
        extra = {
            interest = 1,
            runtime = 3,
            uses = 0,
        }
    },
    origin = {
        'rlm',
        'rlm_botw',
        color = 'rlm'
    },
    artist = 'yunkie101'
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    return { vars = { card.ability.extra.interest, card.ability.extra.runtime-card.ability.extra.uses } }
end

function consumInfo.calculate(self, card, context)
    local bad_context = context.repetition or context.individual or context.blueprint
    if card.ability.activated and context.starting_shop and not card.debuff and not bad_context then
        card.ability.extra.uses = card.ability.extra.uses+1
    end
    if context.starting_shop and not context.blueprint then
        if to_big(card.ability.extra.uses) >= to_big(card.ability.extra.runtime) then
            G.FUNCS.destroy_tape(card)
            card.ability.destroyed = true
        end
    end
end

function consumInfo.activate(self, card, on)
    if on then
        G.GAME.interest_amount = G.GAME.interest_amount + card.ability.extra.interest
    else
        G.GAME.interest_amount = G.GAME.interest_amount - card.ability.extra.interest
    end
end

function consumInfo.can_use(self, card)
    if to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit) or card.area == G.consumeables then return true end
end

return consumInfo