local consumInfo = {
    name = 'Yo-Yo Man Instructional Video',
    atlas = 'vhs',
	pos = {x = 6, y = 4},
    set = "VHS",
    runtime = 5,
    cost = 6,
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
    if context.blueprint or card.debuff then return end

    if context.return_card_to_hand and card.ability.activated and SMODS.in_scoring(context.card, context.scoring_hand) then
		return {
			return_card = true
		}
	end

    if context.after and card.ability.activated then
        ArrowAPI.vhs.run_tape(card)
    end
end

return consumInfo