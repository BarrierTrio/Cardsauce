local consumInfo = {
    name = 'Yo-Yo Man Instructional Video',
    atlas = 'vhs',
	pos = {x = 6, y = 4},
    set = "VHS",
    runtime = 5,
    cost = 3,
    alerted = true,
    config = {},
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'vinny',
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

function consumInfo.calculate(self, card, context)
    if context.after and card.ability.activated and not context.blueprint then
        ArrowAPI.vhs.run_tape(card)
    end
end

return consumInfo