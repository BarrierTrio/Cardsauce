local consumInfo = {
    name = 'SOS',
    key = 'sos',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        activated = false,
        destroyed = false,
        extra = {
            runtime = 3,
            uses = 0,
            x_mult = 3,
            prob = 2,
        },
    },
    origin = {
        'rlm',
        'rlm_wotw',
        color = 'rlm'
    }
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    return { vars = {  SMODS.get_probability_vars(card, 1, card.ability.extra.prob), card.ability.extra.x_mult, card.ability.extra.runtime-card.ability.extra.uses } }
end

function consumInfo.calculate(self, card, context)
    if context.joker_main and card.ability.activated and SMODS.pseudorandom_probability(card, pseudoseed('csau_sos'), 1, card.ability.extra.prob) then
        return {
            x_mult = card.ability.extra.x_mult,
            card = card
        }
    end

    if context.after and not card.ability.destroyed and card.ability.activated then
        card.ability.extra.uses = card.ability.extra.uses + 1
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