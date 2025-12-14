local consumInfo = {
    name = 'Star Wars Holiday Special',
    atlas = 'vhs',
	pos = {x = 5, y = 0},
    set = "VHS",
    runtime = 3,
    cost = 3,
    alerted = true,
    config = {
        extra = {
            dollars = 1,
        },
    },
    artist = 'chvsau'
}

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.dollars } }
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if card.ability.activated and context.individual and context.cardarea == G.play then
        return {
            dollars = card.ability.extra.dollars
        }
    end

    if context.after and card.ability.activated and not context.blueprint then
        ArrowAPI.vhs.run_tape(card)
    end
end

return consumInfo