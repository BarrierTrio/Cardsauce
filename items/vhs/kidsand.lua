local consumInfo = {
    name = 'Kid Sand Airbags',
    set = "VHS",
    runtime = 3,
    cost = 3,
    config = {
        extra = {
            discard_mod = 1,
        }
    },
    origin = {
        category = 'rlm',
        sub_origins = {
            'rlm_wotw',
        },
        custom_color = 'rlm'
    },
    artist = 'yunkie101'
}


function consumInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.discard_mod } }
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if card.ability.activated and context.setting_blind then
        ease_discard(card.ability.extra.discard_mod)

        if not context.blueprint then
            ArrowAPI.vhs.run_tape(card)
        end

        return {
            card = context.blueprint_card or card,
            message = localize{type = 'variable', key = 'a_plus_discard', vars = {card.ability.extra.discard_mod}},
            colour = G.C.RED
        }
    end
end

return consumInfo