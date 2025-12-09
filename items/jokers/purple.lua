local jokerInfo = {
    name = 'The Purple Joker',
    atlas = 'jokers',
	pos = {x = 5, y = 0},
    config = {
        extra = {
            suit = 'Spades',
        }
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    origin = 'vinny',
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'sinewuui'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return {
        vars = {
            localize(card.ability.extra.suit, 'suits_plural'),
            colours = {
                G.C.SUITS[card.ability.extra.suit]
            }
        }
    }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.before and to_big(G.consumeables.config.card_limit + G.GAME.consumeable_buffer) > to_big(#G.consumeables.cards)
    and next(context.poker_hands['Flush']) and ArrowAPI.game.all_same_suit(context.poker_hands['Flush'][1], card.ability.extra.suit) then
        if ArrowAPI.vhs.find_activated_tape('c_csau_rawtime') then check_for_unlock({ type = "wheres_po" }) end

        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
         G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.add_card({set = 'Tarot'})
                G.GAME.consumeable_buffer = 0
                return true
            end
        }))

        return {
            message = localize('k_plus_tarot'),
            colour = G.C.PURPLE,
            card = context.blueprint_card or card
        }
    end
end

return jokerInfo
