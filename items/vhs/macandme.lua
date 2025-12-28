local consumInfo = {
    name = 'Mac and Me',
    atlas = 'vhs',
	pos = {x = 0, y = 3},
    set = "VHS",
    runtime = 2,
    cost = 3,
    alerted = true,
    config = {
        extra = {
            retrigger = 1,
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
    return { vars = { card.ability.runtime-card.ability.uses } }
end

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.cardarea == G.play and context.repetition then
        if (context.scoring_hand[1] and context.other_card == context.scoring_hand[1]) or (context.scoring_hand[2] and context.other_card == context.scoring_hand[2]) then
            return {
                message = 'Again!',
                repetitions = card.ability.extra.retrigger,
                card = card
            }
        end
    end
    if context.after and card.ability.activated and not context.blueprint then
        ArrowAPI.vhs.run_tape(card)
    end
end

return consumInfo