local jokerInfo = {
    name = "Beginner's Luck",
    atlas = 'jokers',
	pos = {x = 7, y = 7},
    config = {
        extra = {
            prob_mod = 3,
            ante = 4
        }
    },
    rarity = 2,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    origin = 'vinny',
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'BarrierTrio/Gote'
}

function jokerInfo.in_pool(self, args)
    return to_big(G.GAME.round_resets.ante) <= to_big(self.config.extra.ante)
end

function jokerInfo.calculate(self, card, context)
    if context.mod_probability and to_big(G.GAME.round_resets.ante) <= to_big(card.ability.extra.ante) then
        return {
            numerator = context.numerator * card.ability.extra.prob_mod
        }
    end
end

function jokerInfo.update(self, card)
    if to_big(G.GAME.round_resets.ante) > to_big(card.ability.extra.ante) then
        card.debuff = true
    else
        card.debuff = false
    end
end

return jokerInfo