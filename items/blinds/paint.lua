local blindInfo = {
    name = "The Paint",
    color = HEX('6957b0'),
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    vars = {},
    boss = {min = 4, max = 10},
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    }
}

function blindInfo.defeat(self)
    check_for_unlock({ type = "defeat_paint" })
end

function blindInfo.modify_hand(self, cards, poker_hands, text, mult, hand_chips)
    -- only use non face ranks
    -- this would support modded numbered ranks, thank you 161 of clubs
    local rand_suits = {}
    for _, suit in pairs(SMODS.Suits) do
        rand_suits[suit.key] = suit.card_key
    end

    -- record flip cards and do initial flip
    local change_cards = {}
    for _, hand_card in ipairs(poker_hands[text][1]) do
        local rank = SMODS.Ranks[hand_card.base.value].card_key
        local current_suit = SMODS.Suits[hand_card.base.suit]

        -- don't transform into current suit
        local replace_suit = false
        if rand_suits[current_suit.key] then
            rand_suits[current_suit.key] = nil
            replace_suit = true
        end

        local change_to_suit = pseudorandom_element(rand_suits, pseudoseed('paintblind'))
        hand_card:set_base(G.P_CARDS[change_to_suit..'_'..rank], nil, true)
        change_cards[#change_cards+1] = hand_card

        -- put it back
        if replace_suit then
            rand_suits[current_suit.key] = current_suit.card_key
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                hand_card:flip()
                play_sound('card1')
                hand_card:juice_up(0.3, 0.3)
                return true
            end
        }))
    end

    -- during hang, set base
    for i=1, #change_cards do
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                change_cards[i]:set_sprites(nil, G.P_CARDS[change_cards[i].config.card_key])
                return true
            end
        }))
    end

    -- do flip back over
    for i=1, #change_cards do
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.25,
            func = function()
                change_cards[i]:flip()
                play_sound('tarot2', 1, 0.6)
                change_cards[i]:juice_up(0.3, 0.3)
                return true
            end
        }))
    end
    delay(0.2)

    return mult, hand_chips, false
end

return blindInfo