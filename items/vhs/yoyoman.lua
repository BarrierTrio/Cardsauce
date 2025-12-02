local consumInfo = {
    name = 'Yo-Yo Man Instructional Video',
    key = 'yoyoman',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        extra = {
            runtime = 5,
            uses = 0,
        },
        activated = false,
        destroyed = false,
    },
    origin = {
        category = 'vinny',
        sub_origins = {
            'vinny_wotw',
        },
        custom_color = 'vinny'
    },
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'MightyKingWario'
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    return { vars = { card.ability.extra.runtime-card.ability.extra.uses } }
end

function consumInfo.calculate(self, card, context)
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