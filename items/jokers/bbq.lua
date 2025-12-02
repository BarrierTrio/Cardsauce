local jokerInfo = {
    name = 'Barbeque Shoes',
    atlas = 'jokers',
	pos = {x = 5, y = 11},
    config = {
        extra = {
            suit = 'Hearts',
            suits_inc = 5,
            dollars_mod = 2,
        }
    },
    rarity = 1,
    cost = 7,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'creachurearts'
}

local function get_payout(card)
    if not G.playing_cards then return 0 end
    local suits = 0
    for k, v in pairs(G.playing_cards) do
        if v:is_suit(card.ability.extra.suit) then suits = suits+1 end
    end
    return math.floor(suits / card.ability.extra.suits_inc) * card.ability.extra.dollars_mod
end

function jokerInfo.loc_vars(self, info_queue, card)
    return {
        vars = {
            card.ability.extra.dollars_mod,
            card.ability.extra.suits_inc,
            get_payout(card),
            localize(card.ability.extra.suit, 'suits_plural'),
            colours = {
                G.C.SUITS[card.ability.extra.suit]
            }
        }
    }
end

function jokerInfo.calc_dollar_bonus(self, card)
    if not card.debuff then
        return get_payout(card)
    end
end

return jokerInfo