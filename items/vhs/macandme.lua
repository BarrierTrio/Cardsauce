local consumInfo = {
    name = 'Mac and Me',
    atlas = 'vhs',
	pos = {x = 0, y = 3},
    set = "VHS",
    runtime = 3,
    cost = 6,
    alerted = true,
    config = {
        extra = {
            num_cards = 2,
            retrigger = 2,
        }
    },
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'joel',
        },
        custom_color = 'joel'
    },
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'Gongalicious'
}


function consumInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.num_cards, card.ability.extra.retrigger } }
end

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.cardarea == G.play and context.repetition then
        for i=1, card.ability.extra.num_cards do
            if context.scoring_hand[i] and context.other_card == context.scoring_hand[i] then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.retrigger,
                    card = card
                }
            end
        end
    end

    if context.after and card.ability.activated and not context.blueprint then
        ArrowAPI.vhs.run_tape(card)
    end
end

return consumInfo