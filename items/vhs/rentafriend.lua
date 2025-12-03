local consumInfo = {
    name = 'Rent-a-Friend',
    key = 'rentafriend',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        extra = {
            runtime = 1,
            uses = 0,
        },
        activated = false,
        destroyed = false,
    },
    origin = {
        category = 'vinny',
        sub_origins = {
            'vinny_wotw',
        },
        custom_color = 'vinny'
    },
    artist = 'ABBurlap'
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
    if card.ability.activated and not card.ability.destroyed and context.created_card
    and context.area and context.area == G.shop_jokers then
        card:set_edition({ negative = true }, true)
        card:set_rental(true)

        card.ability.uses = card.ability.uses+1
        if to_big(card.ability.uses) >= to_big(card.ability.runtime) then
            ArrowAPI.vhs.destroy_tape(card)
            card.ability.destroyed = true
        end
    end
end

return consumInfo