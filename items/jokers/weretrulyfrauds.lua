local jokerInfo = {
    name = "WE'RE TRULY FRAUDS!",
    atlas = 'jokers',
	pos = {x = 6, y = 14},
    config = {
        extra = {
            discount = 0
        }
    },
    rarity = 2,
    cost = 8,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    dependencies = {
        config = {
            ['VinnyContent'] = true,
            ['VHSs'] = true
        }
    },
    origin = {
        category = 'rlm',
        sub_origins = {'rlm_wotw'},
        custom_color = 'rlm'
    },
    artist = 'Lyzerus'
}

function jokerInfo.in_pool(self, args)
    return not not G.GAME.used_vouchers.v_arrow_scavenger
end

function jokerInfo.add_to_deck(self, card, from_debuff)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.15,
        func = function()
            ArrowAPI.game.set_center_discount(card, card.ability.extra.discount, true, 'VHS')
            ArrowAPI.game.set_center_discount(card, card.ability.extra.discount, true, 'Booster', 'VHS')
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
