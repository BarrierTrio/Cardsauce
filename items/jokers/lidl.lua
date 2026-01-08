local jokerInfo = {
    name = 'Lidl',
    atlas = 'jokers',
	pos = {x = 4, y = 9},
    config = {
        extra = {
            dollars_mod = 2,
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

local function get_voucher_count()
    if G.GAME and G.GAME.used_vouchers then
        local count = 0
        for k, v in pairs(G.GAME.used_vouchers) do
            if v then count = count + 1 end
        end
        return count
    else
        return 0
    end
end

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.dollars_mod, (get_voucher_count() * card.ability.extra.dollars_mod) } }
end

function jokerInfo.calc_dollar_bonus(self, card)
    if not card.debuff then
        return ( get_voucher_count() * card.ability.extra.dollars_mod )
    end
end

return jokerInfo