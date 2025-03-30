local jokerInfo = {
    name = "Rotten Joker",
    config = {
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "othervinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.akai } }
end

function jokerInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_rotten" })
end

function jokerInfo.calculate(self, card, context)
    if context.setting_blind and not card.getting_sliced and not card.debuff then
        local least_played_num = (G.GAME.hands["High Card"].played or 10000)
        for k, v in pairs(G.GAME.hands) do
            if v.played <= least_played_num and v.visible then
                least_played_num = v.played
            end
        end
        local least_pool = {}
        for k, v in pairs(G.GAME.hands) do
            if v.played == least_played_num and v.visible then
                least_pool[#least_pool + 1] = k
            end
        end
        local level_hand = least_pool[pseudorandom('rottenwomb', 1, #least_pool)]
        if level_hand then
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(level_hand, 'poker_hands'),chips = G.GAME.hands[level_hand].chips, mult = G.GAME.hands[level_hand].mult, level=G.GAME.hands[level_hand].level})
            level_up_hand(context.blueprint_card or card, level_hand, nil, 1)
            update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
        end
    end
end

return jokerInfo