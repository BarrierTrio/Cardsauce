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
    streamer = "joel",
    artist = 'MightyKingWario'
}

local function get_mult(card)
    if G.GAME.consumeable_usage and G.GAME.consumeable_usage['c_fool'] then
        if to_big(G.GAME.consumeable_usage['c_fool'].count) > to_big(0) then
            return G.GAME.consumeable_usage['c_fool'].count * card.ability.extra.mult_mod
        end
    end
    return 0
end

function jokerInfo.loc_vars(self, info_queue, card)
    return {
        vars = { card.ability.extra.mult_mod, get_mult(card) },
    }
end

function jokerInfo.calculate(self, card, context)
    if context.using_consumeable then
        if (context.consumeable.config.center.key == "c_fool") and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={get_mult(card)}}}); return true
                end}))
            return nil, true
        end
    end
    if to_big(get_mult(card)) > to_big(0) and context.joker_main and context.cardarea == G.jokers and not card.debuff then
        return {
            mult = get_mult(card),
        }
    end
end

return jokerInfo