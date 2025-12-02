local consumInfo = {
    name = 'Space Cop',
    key = 'spacecop',
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
        },
    },
    origin = 'rlm',
    artist = 'BarrierTrio/Gote'
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    return { vars = { card.ability.extra.runtime-card.ability.extra.uses } }
end

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.modify_level_increment and context.card
    and context.card.ability and context.card.ability.set == 'Planet' then
        card.ability.extra.uses = card.ability.extra.uses+1
        if to_big(card.ability.extra.uses) >= to_big(card.ability.extra.runtime) then
            ArrowAPi.vhs.destroy_tape(card)
            card.ability.destroyed = true
        end

        return {
            mult_inc = 2,
            message = localize('k_spacecop'),
            colour = G.C.SECONDARY_SET.Planet
        }

    end
end

function consumInfo.can_use(self, card)
    if to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit) or card.area == G.consumeables then return true end
end

return consumInfo