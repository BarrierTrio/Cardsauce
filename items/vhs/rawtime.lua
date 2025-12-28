local consumInfo = {
    name = 'rAw TiMe',
    atlas = 'vhs',
	pos = {x = 2, y = 4},
    set = "VHS",
    runtime = 3,
    cost = 3,
    alerted = true,
    config = {
        extra = {
            retrigger = 1,
            valid_ids = {
                [2] = true,
                [4] = true,
                [7] = true
            }
        },
    },
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'vinny',
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

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.cardarea == G.play and context.repetition
    and card.ability.extra.valid_ids[context.other_card:get_id()] then
        return {
            message = 'Again!',
            repetitions = card.ability.extra.retrigger,
            card = context.blueprint_card or card
        }
    end

    if context.after and card.ability.activated and not context.blueprint then
        ArrowAPI.vhs.run_tape(card)
    end
end

return consumInfo