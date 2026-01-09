local jokerInfo = {
    name = "April Fools' Joker",
    atlas = 'jokers',
	pos = {x = 8, y = 12},
    config = {
        extra = {
            mult_mod = 4
        },
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
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
    artist = 'MightyKingWario'
}

local function get_fools()
    if not G.GAME.consumeable_usage or not G.GAME.consumeable_usage['c_fool'] then return 0 end

    return G.GAME.consumeable_usage['c_fool'].count
end

function jokerInfo.loc_vars(self, info_queue, card)
    return {
        vars = { card.ability.extra.mult_mod, get_fools() * card.ability.extra.mult_mod },
    }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if not context.blueprint and context.using_consumeable and context.consumeable.config.center.key == "c_fool" then
        local mult = get_fools() * card.ability.extra.mult_mod
        check_for_unlock({type = 'scale_card', card = card, ref_table = {mult = mult}, ref_value = 'mult'})
        return {
            message = localize {type = 'variable', key = 'a_mult', vars = {mult} },
            colour = G.C.MULT
        }
    end

    if context.joker_main then
        local fools = get_fools()
        if fools > 0 then
            return {
                mult = fools * card.ability.extra.mult_mod,
                card = context.blueprint_card or card
            }
        end
    end
end

return jokerInfo