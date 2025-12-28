local jokerInfo = {
    name = 'Lidl',
    atlas = 'jokers',
	pos = {x = 4, y = 9},
    config = {
        extra = {
            discount = 0.5,
        },
    },
    rarity = 1,
    cost = 6,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
origin = {
        category = 'cardsauce',
        sub_origins = {
            'joel',
        },
        custom_color = 'joel'
    },
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = {'BardVergil', 'Kekulism'}
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.discount * 100 } }
end

function jokerInfo.add_to_deck(self, card, from_debuff)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.15,
        func = function()
            ArrowAPI.game.set_center_discount(card, card.ability.extra.discount, true, 'Voucher')
            return true
        end
    }))
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.15,
        func = function()
            ArrowAPI.game.clear_discount(card)
            return true
        end
    }))
end

return jokerInfo