local consumInfo = {
    name = 'Rent-a-Friend',
    atlas = 'vhs',
	pos = {x = 4, y = 2},
    set = "VHS",
    runtime = 5,
    cost = 3,
    blueprint_compat = false,
    config = {
        activation = true,
        extra = {
            runtime = 1,
            uses = 0,
        },
        activated = false,
        destroyed = false,
    },
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'vinny',
            'vinny_wotw',
        },
        custom_color = 'vinny'
    },
    artist = 'ABBurlap'
}

function consumInfo.calculate(self, card, context)
    if card.debuff or context.blueprint then return end

    if card.ability.activated and not card.ability.destroyed and context.created_card
    and context.area and context.area == G.shop_jokers then
        card:set_edition({ negative = true }, true)
        card:set_rental(true)

        ArrowAPI.vhs.run_tape(card)
    end
end

return consumInfo