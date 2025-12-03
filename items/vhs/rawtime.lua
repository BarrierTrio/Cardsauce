local consumInfo = {
    name = 'rAw TiMe',
    key = 'rawtime',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        extra = {
            retrigger = 1,
            runtime = 3,
            uses = 0,
        },
        activated = false,
        destroyed = false,
    },
    origin = {
        category = 'vinny',
        sub_origins = {
            'vinny_pa',
        },
        custom_color = 'vinny'
    },
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'Joey'
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    return { vars = { card.ability.runtime-card.ability.uses } }
end

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.cardarea == G.play and context.repetition and not context.repetition_only then
        if context.other_card:get_id() == 4 or context.other_card:get_id() == 7 or context.other_card:get_id() == 2 then
            return {
                message = 'Again!',
                repetitions = card.ability.extra.retrigger,
                card = card
            }
        end
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