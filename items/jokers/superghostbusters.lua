local jokerInfo = {
    name = "Super Jokebusters",
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
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'BarrierTrio/Gote'
}

local function get_mult(card)
    if G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.spectral then
        if to_big(G.GAME.consumeable_usage_total.spectral) > to_big(0) then
            return G.GAME.consumeable_usage_total.spectral * card.ability.extra
        end
    end
    return 0
end

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra, get_mult(card)} }
end

function jokerInfo.add_to_deck(self, card)
    card.ability.mult = get_mult(card)
end

function jokerInfo.calculate(self, card, context)
    if context.using_consumeable and not context.blueprint then
        if context.consumeable.ability.set == "Spectral" then
            G.E_MANAGER:add_event(Event({ func = function()
                card.ability.mult = get_mult(card)
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={get_mult(card)}}})
                return true
            end}))
        end
    end
    if to_big(get_mult(card)) > to_big(0) and context.joker_main and context.cardarea == G.jokers then
        return {
            mult = get_mult(card),
        }
    end
end

return jokerInfo