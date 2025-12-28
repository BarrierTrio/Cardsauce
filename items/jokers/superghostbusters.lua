local jokerInfo = {
    name = "Super Jokebusters",
    atlas = 'jokers',
	pos = {x = 5, y = 9},
    config = {
        extra = 5,
        mult = 0,
    },
    rarity = 1,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    has_shiny = true,
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
    artist = 'BarrierTrio/Gote'
}

local function get_used_spectrals()
    return (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.spectral or 0)
end

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra, get_used_spectrals() * card.ability.extra} }
end

function jokerInfo.calculate(self, card, context)
    if context.using_consumeable and not context.blueprint and context.consumeable.config.center.set == "Spectral" then
        return {
            message = localize{type='variable',key='a_mult',vars={get_used_spectrals() * card.ability.extra}},
            colour = G.C.MULT
        }
    end

    if context.joker_main then
        local used_spectrals = get_used_spectrals()
        if used_spectrals > 0 then
            return {
                mult = used_spectrals * card.ability.extra,
            }
        end
    end
end

return jokerInfo