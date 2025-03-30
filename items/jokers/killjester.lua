local jokerInfo = {
    name = 'Kill Jester',
    config = {
        x_mult = 1,
        x_mult_mod = 0.25,
    },
    rarity = 3,
    cost = 8,
    unlocked = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    streamer = "vinny",
}

function jokerInfo.check_for_unlock(self, args)
    if args.type == "unlock_killjester" then
        return true
    end
end

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.swizik } }
    return { vars = {card.ability.x_mult_mod, card.ability.x_mult} }
end

function jokerInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_killjester" })
end

local function valid_name(name)
    if containsString(name, "Joker") or containsString(name, "Jester") then
        return true
    end
    return false
end

function jokerInfo.calculate(self, card, context)
    if context.setting_blind and not context.blueprint and not card.getting_sliced and not card.debuff then
        local trigger = false
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] ~= card and not (G.jokers.cards[i].getting_sliced or G.jokers.cards[i].ability.eternal) then
                if valid_name(G.jokers.cards[i].ability.name) then
                    card.ability.x_mult = to_big(card.ability.x_mult) + to_big(card.ability.x_mult_mod)
                    G.jokers.cards[i].getting_sliced = true
                    trigger = true
                    G.E_MANAGER:add_event(Event({func = function()
                        G.jokers.cards[i]:start_dissolve({G.C.RED}, nil, 1.6)
                    return true end }))
                end
            end
        end
        if trigger and not (context.blueprint_card or card).getting_sliced then
            card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.x_mult}}})
        end
    end
    if context.joker_main and context.cardarea == G.jokers then
        return {
            message = localize{type='variable',key='a_xmult',vars={to_big(card.ability.x_mult)}},
            Xmult_mod = card.ability.x_mult,
        }
    end
end

return jokerInfo