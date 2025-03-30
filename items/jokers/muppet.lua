local jokerInfo = {
    name = "Movin' Right Along",
    config = {
        dollars_before = nil,
        extra = {
            x_mult = 1,
            x_mult_mod = 0.5,
        }
    },
    rarity = 2,
    cost = 5,
    unlocked = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    streamer = "other",
}

function jokerInfo.check_for_unlock(self, args)
    if args.type == "continue_game" then
        return true
    end
end

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.jen } }
    return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_mod } }
end

function jokerInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_muppet" })
end

function jokerInfo.calculate(self, card, context)
    if context.ending_shop and not context.blueprint then
        if card.ability.dollars_before and G.GAME.dollars == card.ability.dollars_before then
            card.ability.extra.x_mult = to_big(card.ability.extra.x_mult) + to_big(card.ability.extra.x_mult_mod)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {to_big(card.ability.extra.x_mult)}}, colour = G.C.MULT})
        end
        card.ability.dollars_before = nil
    end
    if context.joker_main and context.cardarea == G.jokers then
        return {
            message = localize{type='variable',key='a_xmult',vars={to_big(card.ability.extra.x_mult)}},
            Xmult_mod = card.ability.extra.x_mult,
            --colour = G.C.MULT
        }
    end
end

local shopref = G.UIDEF.shop
function G.UIDEF.shop()
    local t = shopref()
    -- Wrap this in an event for it to get dollars after ease_dollars
    G.E_MANAGER:add_event(Event({trigger = 'after', blocking = false, func = function()
        for _, v in ipairs(SMODS.find_card("j_csau_muppet")) do
            v.ability.dollars_before = G.GAME.dollars
        end
    return true end }))
    return t
end

return jokerInfo