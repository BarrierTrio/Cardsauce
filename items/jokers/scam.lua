local jokerInfo = {
    name = 'BITCONNEEEEEEEEEEEEEEEEE',
    atlas = 'jokers',
	pos = {x = 7, y = 12},
    config = {
        extra = {
            dollars = 5,
            scam_hands = {
                ["High Card"] = true,
                ["Pair"] = true,
                ["Two Pair"] = true,
            }
        },
    },
    rarity = 2,
    cost = 8,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    pools = {
        ["Meme"] = true
    },
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'joel',
        },
        custom_color = 'joel'
    },
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'plunch'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.dollars } }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.before then
        local money = card.ability.extra.dollars * (card.ability.extra.scam_hands[context.scoring_name] and -1 or 1)
        return {
            dollars = money
        }
    end
end

return jokerInfo