local jokerInfo = {
    name = 'The Purple Joker',
    atlas = 'jokers',
	pos = {x = 5, y = 0},
    config = {
        extra = {
            suit = 'Spaces',
            tarots = 1
        }
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "vinny",
    artist = 'sinewuui'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return {
        vars = {
            card.ability.tarots,
            localize(card.ability.extra.suit, 'suits_plural'),
            colours = {
                G.C.SUITS[card.ability.extra.suit]
            }
        }
    }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff or to_big(#G.consumeables.cards) >= to_big(G.consumeables.config.card_limit) then return end

    if context.before and next(context.poker_hands['Flush'])
    and ArrowAPI.game.all_same_suit(context.poker_hands['Flush'][1], card.ability.extra.suit)then
        if ArrowAPI.vhs.find_activated_tape('c_csau_rawtime') then check_for_unlock({ type = "wheres_po" }) end

        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        G.E_MANAGER:add_event(Event({func = function()
            play_sound('timpani')
            local _card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'imthepurpleone')
            _card:add_to_deck()
            G.consumeables:emplace(_card)
            card:juice_up(0.3, 0.5)
            G.GAME.consumeable_buffer = 0
            return true
        end }))

        return {
            message = localize('k_plus_tarot'),
            colour = G.C.PURPLE,
            card = context.blueprint_card or card
        }
    end
end

return jokerInfo
