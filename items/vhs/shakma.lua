local consumInfo = {
    name = 'Shakma',
    key = 'shakma',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        activated = false,
        destroyed = false,
        extra = {
            runtime = 4,
            uses = 0
        },
    },
    origin = {
        'rlm',
        'rlm_botw',
        color = 'rlm'
    },
    artist = 'Joey'
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    return { vars = { card.ability.extra.runtime-card.ability.extra.uses } }
end

function consumInfo.calculate(self, card, context)
    if card.ability.activated and not card.ability.destroyed and context.fix_probability and G.FUNCS.find_activated_tape('c_csau_shakma') == card then
        if context.from_roll then
            card.ability.extra.uses = math.min(card.ability.extra.runtime, card.ability.extra.uses + 1)
            if to_big(card.ability.extra.uses) >= to_big(card.ability.extra.runtime) then
                G.FUNCS.destroy_tape(card)
                card.ability.destroyed = true
            end
        end

        return {
            message = context.from_roll and 'Guaranteed!' or nil,
            numerator = context.denominator,
            denominator = context.denominator,
        }
    end
end

function consumInfo.can_use(self, card)
    if to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit) or card.area == G.consumeables then return true end
end

return consumInfo