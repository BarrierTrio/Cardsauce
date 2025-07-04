local jokerInfo = {
    name = 'THE FLUSHER™',
    config = {
        extra = {
            prob = 5,
            prob_extra = 1,
            prob_mod = 1,
        },
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "joel",
}


function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } }
    local num, dom = SMODS.get_probability_vars(card, card.ability.extra.prob_extra, card.ability.extra.prob)
    return { vars = {num, dom, card.ability.extra.prob_mod } }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.cardarea == G.jokers and context.before and context.scoring_name == "Flush"
    and SMODS.pseudorandom_probability(card, pseudoseed('csau_flusher'), card.ability.extra.prob_extra, card.ability.extra.prob) then
        return {
            card = card,
            level_up = true,
            message = localize('k_level_up_ex')
        }
    end

    if context.blueprint then return end

    if context.selling_card and context.card.config.center.consumeable then
        card.ability.extra.prob_extra = card.ability.extra.prob_extra + 1
        return {
            card = card,
            message = localize{type = 'variable', key = 'a_chance', vars = {SMODS.get_probability_vars(card, card.ability.extra.prob_extra, card.ability.extra.prob)}},
            colour = G.C.GREEN
        }
    end

    if context.end_of_round and to_big(card.ability.extra.prob_extra) > to_big(0) then
        card.ability.extra.prob_extra = 1
        return {
            message = localize('k_reset'),
            colour = G.C.GREEN
        }
    end
end

return jokerInfo
	