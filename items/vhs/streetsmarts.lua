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

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.mult}}
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if card.ability.activated and context.joker_main and G.GAME.current_round.hands_left == 0 then
        ArrowAPI.vhs.run_tape(card)
        return {
            mult = card.ability.extra.mult
        }
    end
end

return consumInfo