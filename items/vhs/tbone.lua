local consumInfo = {
    name = 'Double Down',
    key = 'tbone',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        extra = {
            mult = 5,
            runtime = 3,
            uses = 0,
        },
        activated = false,
        destroyed = false,
    },
    origin = {
        'vinny',
        'vinny_wotw',
        color = 'vinny'
    },
    artist = 'Gongalicious'
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    return { vars = { card.ability.extra.mult, card.ability.extra.runtime-card.ability.extra.uses } }
end

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.other_joker then
        G.E_MANAGER:add_event(Event({
            func = function()
                context.other_joker:juice_up(0.5, 0.5)
                return true
            end
        }))
        return {
            message = localize{type='variable',key='a_mult',vars={to_big(card.ability.extra.mult)}},
            mult_mod = card.ability.extra.mult
        }
    end
    local bad_context = context.repetition or context.individual or context.blueprint
    if context.after and not card.ability.destroyed and card.ability.activated and not bad_context then
        card.ability.extra.uses = card.ability.extra.uses+1
        if to_big(card.ability.extra.uses) >= to_big(card.ability.extra.runtime) then
            G.FUNCS.destroy_tape(card)
            card.ability.destroyed = true
        end
    end
end

function consumInfo.can_use(self, card)
    if to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit) or card.area == G.consumeables then return true end
end

return consumInfo