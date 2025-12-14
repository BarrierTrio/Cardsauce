local consumInfo = {
    name = 'Don Beveridge Customerization Seminar',
    atlas = 'vhs',
	pos = {x = 3, y = 4},
    set = "VHS",
    runtime = 5,
    cost = 3,
    config = {},
    blueprint_compat = false,
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'rlm',
            'rlm_bs',
        },
        custom_color = 'rlm'
    },
    artist = 'chvsau'
}

function consumInfo.calculate(self, card, context)
    if card.debuff or context.blueprint then return end

    if context.food_expires and context.expires then
        if not context.check then
            ArrowAPI.vhs.run_tape(card)
        end

        return {
            food_expires = false
        }
    end
end

return consumInfo