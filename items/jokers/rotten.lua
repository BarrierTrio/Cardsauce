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
    if card.debuff then return end

    if context.setting_blind then
        local lowest = math.huge
        local lowest_pool = {}
        for _, v in pairs(G.handlist) do
            local hand = G.GAME.hands[v]
            if hand.visible and hand.played < lowest then
                lowest = hand.played
                lowest_pool = {v}
            elseif hand.played == lowest then
                lowest_pool[#lowest_pool+1] = v
            end
        end

        local level_hand = pseudorandom_element(lowest_pool, pseudoseed('rottenwomb'))
        SMODS.smart_level_up_hand(context.blueprint_card or card, level_hand, nil, 1)
    end
end

return jokerInfo