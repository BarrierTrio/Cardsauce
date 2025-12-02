local jokerInfo = {
    name = "April Fools' Joker",
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
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'MightyKingWario'
}

local function get_fools()
    if not G.GAME.consumeable_usage and not G.GAME.consumeable_usage['c_fool'] then return 0 end
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
        return {
            message = localize {type = 'variable', key = 'a_mult', vars = {get_fools() * card.ability.extra.mult_mod} },
            colour = G.C.MULT
        }
    end

    if context.joker_main then
        local fools = get_fools()
        if fools > to_big(0) then
            return {
                mult = fools * card.ability.extra.mult_mod,
                card = context.blueprint_card or card
            }
        end
    end
end

return jokerInfo