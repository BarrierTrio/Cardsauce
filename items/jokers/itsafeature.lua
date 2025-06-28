local jokerInfo = {
    name = "IT'S A FEATURE",
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
    streamer = "joel",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.burlap } }
    return { vars = { card.ability.extra.money_mod, SMODS.get_probability_vars(card, 1, card.ability.extra.prob), card.ability.extra.money, } }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.before and not context.blueprint then
        card.ability.extra.money = card.ability.extra.money + card.ability.extra.money_mod
        if to_big(card.ability.extra.money) >= to_big(card.abiltiy.extra.ach_dollars) then
            check_for_unlock({ type = "high_feature" })
        end

        if to_big(card.ability.extra.money) > to_big(0) and SMODS.pseudorandom_probability(card, pseudoseed('csau_feature'), 1, card.ability.extra.prob) then
            card.ability.csau_feature_activated = true
        end

        return {
            message = localize('$')..card.ability.extra.money,
            colour = G.C.ATTENTION,
        }
    end

    if context.joker_main and card.ability.csau_feature_activated and context.scoring_name == "Straight" then
        return {
            dollars = card.ability.extra.money
        }
    end

    if context.after and card.ability.csau_feature_activated and not context.blueprint then
        card.ability.extra.money = 0
        card.ability.csau_feature_activated = nil
        return {
            message = localize('k_reset'),
            card = card
        }
    end
end

return jokerInfo