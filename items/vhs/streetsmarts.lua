local consumInfo = {
    name = 'Street Smarts: Straight Talk For Kids, Teens & Parents',
    atlas = 'vhs',
	pos = {x = 2, y = 2},
    set = "VHS",
    runtime = 3,
    cost = 3,
    alerted = true,
    config = {
        extra = {
            mult = 20,
        },
    },
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'rlm',
            'rlm_j',
        },
        custom_color = 'rlm'
    },
    artist = 'yumz'
}

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if card.ability.activated and context.joker_main and G.GAME.current_round.hands_left == 0 then
        return {
            mult = card.ability.extra.mult
        }
    end

    if card.ability.activated and context.end_of_round and context.main_eval and not context.blueprint then
        ArrowAPI.vhs.run_tape(card)
    end
end

return consumInfo