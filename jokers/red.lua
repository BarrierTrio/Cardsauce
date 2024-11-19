local jokerInfo = {
    name = 'Why Are You Red?',
    config = {
        suit_conv = "Hearts",
        prob = 4
    },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "guestartist9", set = "Other"}
    return { vars = {G.GAME.probabilities.normal, card.ability.prob} }
end

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and context.before and not card.debuff then
        send("Current hand: "..G.GAME.last_hand_played)
        local last_hand = G.GAME.last_hand_played
        if pseudorandom('red') < G.GAME.probabilities.normal / card.ability.prob then
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_red'), colour = G.C.RED})
            for i=1, #context.scoring_hand do
                local percent = 1.15 - (i-0.999)/(#context.scoring_hand-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'before',delay = 0.15,func = function() context.scoring_hand[i]:flip();play_sound('card1', percent);context.scoring_hand[i]:juice_up(0.3, 0.3);return true end }))
            end
            for i=1, #context.scoring_hand do
                G.E_MANAGER:add_event(Event({trigger = 'before',delay = 0.1,func = function() context.scoring_hand[i]:change_suit(card.ability.suit_conv);return true end }))
            end
            for i=1, #context.scoring_hand do
                local percent = 0.85 + (i-0.999)/(#context.scoring_hand-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'before',delay = 0.15,func = function() context.scoring_hand[i]:flip();play_sound('tarot2', percent, 0.6);context.scoring_hand[i]:juice_up(0.3, 0.3);return true end }))
            end
            local scoring = {}
            for i=1, #context.scoring_hand do
                local _card = context.scoring_hand[i]
                _card.base.suit = "Hearts"
                table.insert(scoring, _card)
            end
            local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(scoring)
            send("Hand converted to all Hearts: "..text)
            if G.GAME.current_round.current_hand.handname ~= disp_text then delay(0.3) end
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0, blockable = false,
                 func = function()
                     send("2")
                     if text ~= G.GAME.last_hand_played then
                         G.GAME.hands[G.GAME.last_hand_played].played = G.GAME.hands[G.GAME.last_hand_played].played - 1
                         G.GAME.hands[G.GAME.last_hand_played].played_this_round = G.GAME.hands[G.GAME.last_hand_played].played_this_round + 1
                     end
                     G.GAME.hands[text].played = G.GAME.hands[text].played + 1
                     G.GAME.hands[text].played_this_round = G.GAME.hands[text].played_this_round + 1
                     G.GAME.last_hand_played = text
                     set_hand_usage(text)
                     G.GAME.hands[text].visible = true
                     update_hand_text({sound = G.GAME.current_round.current_hand.handname ~= disp_text and 'button' or nil, volume = 0.4, immediate = true, nopulse = true,
                                       delay = G.GAME.current_round.current_hand.handname ~= disp_text and 0.4 or 0}, {handname=disp_text, level=G.GAME.hands[text].level, mult = G.GAME.hands[text].mult, chips = G.GAME.hands[text].chips})
                     return true
                 end
            }))
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0, blockable = false,
                 func = function()
                     update_hand_text({sound = G.GAME.current_round.current_hand.handname ~= last_hand and 'button' or nil, volume = 0.4, immediate = true, nopulse = true,
                                       delay = G.GAME.current_round.current_hand.handname ~= last_hand and 0.4 or 0}, {handname=last_hand, level=G.GAME.hands[last_hand].level, mult = G.GAME.hands[last_hand].mult, chips = G.GAME.hands[last_hand].chips})
                     return true
                 end
            }))
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 4.5, blockable = false,
                 func = function()
                     update_hand_text({sound = G.GAME.current_round.current_hand.handname ~= disp_text and 'button' or nil, volume = 0.4, immediate = true, nopulse = nil,
                                       delay = G.GAME.current_round.current_hand.handname ~= disp_text and 0.4 or 0}, {handname=disp_text, level=G.GAME.hands[text].level, mult = G.GAME.hands[text].mult, chips = G.GAME.hands[text].chips})
                     return true
                 end
            }))
            return {
                update_hand = text,
                delay = 4.5,
                silent = true
            }
        end
    end
end

return jokerInfo

