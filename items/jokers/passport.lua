local jokerInfo = {
    name = "Passport",
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
    streamer = "joel",
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

local function get_x_mult(card)
    if G.GAME.used_vouchers then
        if voucher_count() > 0 then
            return 1 + (voucher_count()*card.ability.extra.x_mult_mod)
        else
            return 1
        end
    else
        return 1
    end
end

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult_mod, get_x_mult(card) } }
end

function jokerInfo.add_to_deck(self, card)
    card.ability.extra.x_mult = get_x_mult(card)
end

function jokerInfo.calculate(self, card, context)
    if context.buying_card and not context.blueprint then
        if context.card.ability.set == "Voucher" then
            G.E_MANAGER:add_event(Event({ func = function()
                card.ability.extra.x_mult = get_x_mult(card)
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {get_x_mult(card)}}})
                return true
            end}))
        end
    end
    if get_x_mult(card) > 0 and context.joker_main and context.cardarea == G.jokers then
        return {
            x_mult = get_x_mult(card),
        }
    end
end

return jokerInfo