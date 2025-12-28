local jokerInfo = {
    name = "Monkey Mondays",
    atlas = 'jokers',
	pos = {x = 0, y = 13},
    config = {
        extra = {
            mult = 5,
            prob = 6,
        },
    },
    unlocked = false,
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
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
    artist = 'Lyzerus'
}

function jokerInfo.loc_vars(self, info_queue, card)
    local num, dom = SMODS.get_probability_vars(card, 1, card.ability.extra.prob, 'csau_monkey')
    return { vars = { card.ability.extra.mult, num, dom } }
end

function jokerInfo.check_for_unlock(self, args)
    return args.type == "gros_extinct"
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.individual and context.cardarea == G.play then
        return {
            mult = card.ability.extra.mult,
            card = context.blueprint_card or card
        }
    end

    if context.blueprint then return end

    if context.destroy_card and context.cardarea == G.play and SMODS.in_scoring(context.destroy_card, context.scoring_hand)
    and SMODS.pseudorandom_probability(card, 'csau_monkey', 1, card.ability.extra.prob) then
        return {
            remove = true
        }
    end
end

return jokerInfo