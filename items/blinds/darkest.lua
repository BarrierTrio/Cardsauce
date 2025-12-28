local blindInfo = {
    name = "The Darkest",
    atlas = 'blinds',
    pos = {x = 0, y = 0},
    boss_colour = HEX('c0a800'),
    dollars = 5,
    mult = 2,
    vars = {},
    boss = {min = 4, max = 10},
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
}

function blindInfo.defeat(self)
    check_for_unlock({ type = "defeat_darkest" })
end

function blindInfo.modify_hand(self, cards, poker_hands, text, mult, hand_chips)
    -- only use non face ranks
    -- this would support modded numbered ranks, thank you 161 of clubs
    local valid_ranks = {}
    for _, rank in pairs(SMODS.Ranks) do
        if not rank.face then valid_ranks[#valid_ranks+1] = rank.card_key end
    end

    -- record flip cards and do initial flip
    local change_cards = {}
    for _, card in ipairs(poker_hands[text][1]) do
        if card:is_face() then
            local suit = SMODS.Suits[card.base.suit].card_key
            local rank = pseudorandom_element(valid_ranks, pseudoseed('darkestblind'))
            card:set_base(G.P_CARDS[suit..'_'..rank], nil, true)
            change_cards[#change_cards+1] = card
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    card:flip()
                    play_sound('card1')
                    card:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
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