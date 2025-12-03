local consumInfo = {
    name = 'Miami Connection',
    set = "VHS",
    runtime = 3,
    cost = 3,
    alerted = true,
    config = {
        extra = {
            draw_mod = 3,
        }
    },
    origin = {
        category = 'rlm',
        sub_origins = {
            'rlm_botw',
        },
        custom_color = 'rlm'
    },
    artist = 'Dolos'
}


function consumInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.draw_mod } }
end

function consumInfo.calculate(self, card, context)
    if context.drawing_cards and card.ability.activated then
        if not context.blueprint then
            ArrowAPI.vhs.run_tape(card)
        end

        return {
            amount = context.amount + card.ability.extra.draw_mod
        }
    end
end

return consumInfo