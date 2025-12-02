local jokerInfo = {
    name = "Rotten Joker",
    atlas = 'jokers',
	pos = {x = 6, y = 8},
    config = {
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    origin = 'vinny',
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'Akai (Balatrostuck)'
}

function jokerInfo.calculate(self, card, context)
    if context.setting_blind and not card.getting_sliced and not card.debuff then
        local lowest = math.huge
        local lowest_pool = {}
        for k, hand in pairs(G.GAME.hands) do
            if hand.visible and hand.played and hand.played < lowest then
                lowest = hand.played
            end
        end
        for k, hand in pairs(G.GAME.hands) do
            if hand.visible and hand.played == lowest then
                table.insert(lowest_pool, k)
            end
        end
        local level_hand = pseudorandom_element(lowest_pool, pseudoseed('rottenwomb'))
        if level_hand then
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(level_hand, 'poker_hands'),chips = G.GAME.hands[level_hand].chips, mult = G.GAME.hands[level_hand].mult, level=G.GAME.hands[level_hand].level})
            level_up_hand(context.blueprint_card or card, level_hand, nil, 1)
            update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
        end
    end
end

return jokerInfo