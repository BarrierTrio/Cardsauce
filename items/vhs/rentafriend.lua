local consumInfo = {
    name = 'Rent-a-Friend',
    atlas = 'vhs',
	pos = {x = 4, y = 2},
    set = "VHS",
    runtime = 5,
    cost = 6,
    blueprint_compat = false,
    config = {
        extra = {
            edition = 'negative',
        }
    },
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'vinny',
            'vinny_wotw',
        },
        custom_color = 'vinny'
    },
    artist = 'ABBurlap'
}

function consumInfo.calculate(self, card, context)
    if card.debuff or context.blueprint then return end

    if card.ability.activated and not card.ability.destroyed and context.modify_shop_card and not context.card.edition then
        local created = context.card
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                created:set_edition({ [card.ability.extra.edition] = true }, true)
                created:set_rental(true)
                return true
            end
        }))

        ArrowAPI.vhs.run_tape(card)
        delay(0.3)
    end
end

return consumInfo