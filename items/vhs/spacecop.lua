local consumInfo = {
    name = 'Space Cop',
    set = "VHS",
    runtime = 3,
    cost = 3,
    alerted = true,
    config = {},
    origin = 'rlm',
    artist = 'BarrierTrio/Gote'
}

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if card.ability.activated and context.modify_level_increment and context.card
    and context.card.ability and context.card.ability.set == 'Planet' then
        if not context.blueprint then
            ArrowAPI.vhs.run_tape(card)
        end

        return {
            mult_inc = 2,
            message = localize('k_spacecop'),
            colour = G.C.SECONDARY_SET.Planet
        }

    end
end

return consumInfo