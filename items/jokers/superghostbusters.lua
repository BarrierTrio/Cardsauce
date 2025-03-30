local jokerInfo = {
    name = "Super Jokebusters",
    config = {
        extra = 3,
    },
    rarity = 1,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "joel",
}

local function get_mult(card)
    if G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.spectral then
        if G.GAME.consumeable_usage_total.spectral > 0 then
            return G.GAME.consumeable_usage_total.spectral * card.ability.extra
        end
    end
    return 0
end

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
    return { vars = {card.ability.extra, get_mult(card)} }
end

function jokerInfo.calculate(self, card, context)
    if context.using_consumeable and not context.blueprint then
        if context.consumeable.ability.set == "Spectral" then
            G.E_MANAGER:add_event(Event({ func = function()
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={get_mult(card)}}})
                return true
            end}))
        end
    end
    if get_mult(card) > 0 and context.joker_main and context.cardarea == G.jokers then
        return {
            mult = get_mult(card),
        }
    end
end

return jokerInfo