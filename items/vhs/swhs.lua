local consumInfo = {
    name = 'Star Wars Holiday Special',
    key = 'swhs',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        activated = false,
        destroyed = false,
        extra = {
            dollars = 1,
            runtime = 3,
            uses = 0
        },
    },
    artist = 'chvsau'
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    return { vars = { card.ability.extra.dollars, card.ability.runtime-card.ability.uses } }
end

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.individual and context.cardarea == G.play then
        return {
            dollars = card.ability.extra.dollars
        }
    end
    local bad_context = context.repetition or context.individual or context.blueprint
    if context.after and not card.ability.destroyed and card.ability.activated and not bad_context then
        card.ability.uses = card.ability.uses+1
        if to_big(card.ability.uses) >= to_big(card.ability.runtime) then
            ArrowAPI.vhs.destroy_tape(card)
            card.ability.destroyed = true
        end
    end
end

function consumInfo.can_use(self, card)
    if to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit) or card.area == G.consumeables then return true end
end

return consumInfo