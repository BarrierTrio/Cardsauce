local jokerInfo = {
    name = 'Let Fate Decide',
    config = {},
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.fenix } }
    return { vars = { } }
end



function jokerInfo.calculate(self, card, context)
    if context.end_of_round and not card.debuff and not context.individual and not context.repetition then
        local roll = pseudorandom('fate', 1, 6)
        if roll < 0 and roll < 4 then
            check_for_unlock({ type = "activate_watto" })
        end
        if roll == 1 then
            local key, color = G.FUNCS.csau_get_tag('joker', 'IMAWATTOOO')
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_one')..G.localization.descriptions["Tag"][key].name, colour = color})
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                blocking = false,
                func = (function()
                    add_tag(Tag(key))
                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                    return true
                end)
            }))
        elseif roll == 2 then
            local key, color = G.FUNCS.csau_get_tag('booster', 'ANNIEAREYOUOKAY')
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_one')..G.localization.descriptions["Tag"][key].name, colour = color})
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                blocking = false,
                func = (function()
                    add_tag(Tag(key))
                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                    return true
                end)
            }))
        elseif roll == 3 then
            local key, color = G.FUNCS.csau_get_tag('any', 'ISITALRIGHTTOBEMYSELFAGAIN')
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_two')..G.localization.descriptions["Tag"][key].name, colour = color})
            for i=1, 2 do
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    blocking = false,
                    func = (function()
                        local tag_to_add = Tag(key)
                        if key == 'tag_orbital' then
                            local _poker_hands = {}
                            for k, v in pairs(G.GAME.hands) do
                                if v.visible then _poker_hands[#_poker_hands+1] = k end
                            end
                            tag_to_add.ability.orbital_hand = pseudorandom_element(_poker_hands, pseudoseed('orbital'))
                        end
                        add_tag(tag_to_add)
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                    end)
                }))
            end
        else
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_nope_ex'), colour = G.C.SECONDARY_SET.Tarot})
        end
        return
    end
end

return jokerInfo