local jokerInfo = {
    name = "IT'S A FEATURE",
    atlas = 'jokers',
	pos = {x = 6, y = 13},
    config = {
        extra = {
            money = 0,
            money_mod = 2,
            prob = 2,
            ach_dollars = 50,
        },
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    has_shiny = true,
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
    artist = 'ABBurlap'
}

function jokerInfo.loc_vars(self, info_queue, card)
    local num, dom = SMODS.get_probability_vars(card, 1, card.ability.extra.prob, 'csau_feature')
    return { vars = { card.ability.extra.money_mod, num, dom, card.ability.extra.money } }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.joker_main and card.ability.csau_feature_activated and context.scoring_name == "Straight" then
        return {
            dollars = card.ability.extra.money
        }
    end

    if context.blueprint then return end

    if context.before then
        SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = "money",
            scalar_value = "money_mod",
            scale_message = {
                message = localize('$')..card.ability.extra.money,
                colour = G.C.ATTENTION,
            }
        })

        if to_big(card.ability.extra.money) >= to_big(card.ability.extra.ach_dollars) then
            check_for_unlock({ type = "high_feature" })
        end

        if to_big(card.ability.extra.money) > to_big(0) and SMODS.pseudorandom_probability(card, 'csau_feature', 1, card.ability.extra.prob) then
            card.ability.csau_feature_activated = true
        end
    end

    if context.after and card.ability.csau_feature_activated then
        card.ability.extra.money = 0
        card.ability.csau_feature_activated = nil
        return {
            message = localize('k_reset'),
            card = card
        }
    end
end

return jokerInfo