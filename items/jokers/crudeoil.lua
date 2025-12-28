local jokerInfo = {
    name = 'Crude Oil',
    atlas = 'jokers',
	pos = {x = 0, y = 9},
    config = {
        extra = {
            dollars = 8,
            dollars_mod = 2
        }
    },
    rarity = 1,
    cost = 8,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    has_shiny = true,
    pools = { ["Food"] = true },
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'vinny',
        },
        custom_color = 'vinny'
    },
	dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'Lyzerus'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.dollars, card.ability.extra.dollars_mod } }
end

function jokerInfo.calc_dollar_bonus(self, card)
    if not card.debuff then
        return card.ability.extra.dollars
    end
end

function jokerInfo.calculate(self, card, context)
    if card.debuff or context.blueprint then return end

    if context.starting_shop and SMODS.food_expires(card) then
        card.ability.extra.dollars = card.ability.extra.dollars - card.ability.extra.dollars_mod
        if card.ability.extra.dollars <= 0 then
            check_for_unlock({ type = "expire_crudeoil" })
            ArrowAPI.game.card_expire(card, 'k_drank_ex', G.C.MONEY)
        else
            return {
                message = "-"..localize('$') .. card.ability.extra.dollars_mod,
                colour = G.C.MONEY
            }
        end
    end
end

return jokerInfo
