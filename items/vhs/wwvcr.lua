local consumInfo = {
    name = "Wayne's World VCR Board Game",
    set = "VHS",
    runtime = 3,
    cost = 3,
    alerted = true,
    config = {
        extra = {
            chips = 100,
        },
    },
    origin = {
        category = 'vinny',
        sub_origins = {
            'vinny_wotw',
        },
        custom_color = 'vinny'
    },
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'yumz'
}

function consumInfo.loc_vars(self, info_queue, card)
    return {
        vars = { card.ability.extra.chips },
    }
end

function consumInfo.calculate(self, card, context)
    if context.joker_main and card.ability.activated then
        return {
            chips = card.ability.extra.chips
        }
    end

    if context.after and card.ability.activated and not context.blueprint then
        ArrowAPI.vhs.run_tape(card)
        if card.ability.destroyed then check_for_unlock({ type = "monkey_butt" }) end
    end
end

return consumInfo