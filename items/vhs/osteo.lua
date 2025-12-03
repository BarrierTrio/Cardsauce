local consumInfo = {
    name = 'The Osteoporosis Dance',
    set = "VHS",
    runtime = 3,
    cost = 3,
    alerted = true,
    config = {
        extra = {
            hand_mod = 1,
        },
    },
    origin = {
        category = 'rlm',
        sub_origins = {
            'rlm_wotw',
        },
        custom_color = 'rlm'
    },
    artist = 'Kekulism',
}

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.setting_blind then
        ease_hands_played(1)

        if not context.blueprint then
            ArrowAPI.vhs.run_tape(card)
        end

        return {
            card = context.blueprint_card or card,
            message = localize{type = 'variable', key = 'a_plus_hand', vars = {1}},
            colour = G.C.BLUE
        }
    end
end

return consumInfo