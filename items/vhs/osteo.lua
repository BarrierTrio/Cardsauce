local consumInfo = {
    name = 'The Osteoporosis Dance',
    atlas = 'vhs',
	pos = {x = 1, y = 3},
    set = "VHS",
    runtime = 3,
    cost = 6,
    alerted = true,
    config = {
        extra = {
            hand_mod = 2,
        },
    },
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'rlm',
            'rlm_wotw',
        },
        custom_color = 'rlm'
    },
    artist = 'Kekulism',
}

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.hand_mod}}
end

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.setting_blind then
        ease_hands_played(card.ability.extra.hand_mod)

        if not context.blueprint then
            ArrowAPI.vhs.run_tape(card, 'k_osteo_hold')
        end
    end
end

return consumInfo