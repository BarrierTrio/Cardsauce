local jokerInfo = {
    name = "Passport",
    atlas = 'jokers',
	pos = {x = 7, y = 13},
    config = {
        extra = {
            x_mult_mod = 0.25,
            x_mult = 1,
        },
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
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
    artist = 'SoloDimeKuro'
}

local function voucher_count()
    local vouchers = 0
    for k, v in pairs(G.GAME.used_vouchers) do
        if v then
            vouchers = vouchers + 1
        end
    end
    return vouchers
end

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult_mod, voucher_count() * card.ability.extra.x_mult_mod } }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.buying_card and not context.blueprint and context.card.ability.set == "Voucher" then
        return {
            message = localize{type = 'variable', key = 'a_xmult', vars = { voucher_count() * card.ability.extra.x_mult_mod }},
            colour = G.C.MULT
        }
    end

    if context.joker_main then
        local vouchers = voucher_count()
        if vouchers > 0 then
            return {
                x_mult = voucher_count() * card.ability.extra.x_mult_mod,
            }
        end
    end
end

return jokerInfo