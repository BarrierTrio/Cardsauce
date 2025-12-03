local consumInfo = {
    name = 'Creating Rem Lezar',
    key = 'remlezar',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        unpauseable = true,
        activated = false,
        destroy = false,
        extra = {
            runtime = 1,
            uses = 0,
        }
    },
    origin = 'vinny',
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'greek_shmeek'
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    return {
        vars = {
            card.ability.runtime-card.ability.uses,
            (card.ability.runtime-card.ability.uses) > 1 and 's' or ''
        }
    }
end

function consumInfo.calculate(self, card, context)
    if context.spectral_downside and context.downside
    and not card.ability.destroyed then
        G.E_MANAGER:add_event(Event({
            func = function()
                card:juice_up()
                card.ability.uses = card.ability.uses+1
                if card.ability.uses >= card.ability.runtime then
                    ArrowAPI.vhs.destroy_tape(card)
                    card.ability.destroyed = true
                end
                return true
            end
        }))

        return {
            prevent_downside = true
        }
    end
end

function consumInfo.can_use(self, card)
    if to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit) or card.area == G.consumeables then return true end
end

return consumInfo