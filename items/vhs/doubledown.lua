local consumInfo = {
    name = 'Double Down',
    atlas = 'vhs',
	pos = {x = 7, y = 1},
    set = "VHS",
    runtime = 3,
    cost = 3,
    config = {
        extra = {
            x_mult = 2,
        },
    },
    artist = 'Joey'
}


function consumInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult } }
end

function consumInfo.calculate(self, card, context)
    if context.joker_main and card.ability.activated then
        return {
            x_mult = card.ability.extra.x_mult
        }
    end

    if context.after and card.ability.activated and not context.blueprint then
        ArrowAPI.vhs.run_tape(card)
    end
end

return consumInfo