local consumInfo = {
    name = "T-Bone's World of Clowning",
    set = "VHS",
    runtime = 3,
    cost = 3,
    config = {
        extra = {
            mult = 5,
        },
    },
    origin = {
        category = 'vinny',
        sub_origins = {
            'vinny_wotw',
        },
        custom_color = 'vinny'
    },
    artist = 'Gongalicious'
}

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
end

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.other_joker then
        G.E_MANAGER:add_event(Event({
            func = function()
                context.other_joker:juice_up(0.5, 0.5)
                return true
            end
        }))

        return {
            mult = card.ability.extra.mult,
            card = context.blueprint_card or card
        }
    end

    if context.after and card.ability.activated and not context.blueprint then
       ArrowAPI.vhs.run_tape(card)
    end
end

return consumInfo