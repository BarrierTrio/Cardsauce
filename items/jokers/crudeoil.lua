local jokerInfo = {
    name = 'Crude Oil',
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
    streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.lyzerus } }
    return { vars = { card.ability.extra.dollars, card.ability.extra.dollars_mod } }
end

function jokerInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_crudeoil" })
end

function jokerInfo.calc_dollar_bonus(self, card)
    if not card.debuff then
        return card.ability.extra.dollars
    end
end

local shopref = G.UIDEF.shop
function G.UIDEF.shop()
    local t = shopref()
    if not next(SMODS.find_card('j_csau_bunji')) then
        G.E_MANAGER:add_event(Event({trigger = 'after', blocking = false, func = function()
            for _, v in ipairs(SMODS.find_card("j_csau_crudeoil")) do
                v.ability.extra.dollars = to_big(v.ability.extra.dollars) - to_big(v.ability.extra.dollars_mod)
                if v.ability.extra.dollars <= to_big(0) then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            v.T.r = -0.2
                            v:juice_up(0.3, 0.4)
                            v.states.drag.is = true
                            v.children.center.pinch.x = true
                            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                 func = function()
                                     card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_drank_ex'), colour = G.C.MONEY})
                                     G.jokers:remove_card(v)
                                     v:remove()
                                     v = nil
                                     return true
                                 end
                            }))
                            return true
                        end
                    }))
                else
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card_eval_status_text(v, 'extra', nil, nil, nil, {message = "-"..localize('$') .. to_big(v.ability.extra.dollars_mod), colour = G.C.MONEY})
                            return true
                        end
                    }))
                end
            end
            return true
        end }))
    end
    return t
end



return jokerInfo