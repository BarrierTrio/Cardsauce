local consumInfo = {
    name = 'Ishtar',
    set = "VHS",
    runtime = 3,
    cost = 3,
    config = {
        extra = {
            chips = 87,
            valid_ids = {
                [2] = true,
                [3] = true,
                [4] = true
            }
        },
    },
    origin = {
        category = 'rlm',
        sub_origins = {
            'rlm_botw',
        },
        custom_color = 'rlm'
    },
    artist = 'Burdrehnar'
}


function consumInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.chips } }
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end


    if card.ability.activated and context.individual and context.cardarea == G.play
    and card.ability.extra.valid_ids[context.other_card:get_id()] then
        return {
            chips = card.ability.extra.chips,
            card = context.blueprint_card or card
        }
    end

    if context.after and card.ability.activated and not context.blueprint then
        ArrowAPI.vhs.run_tape(card)
    end
end

return consumInfo