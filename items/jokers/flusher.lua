local jokerInfo = {
    name = 'THE FLUSHER™',
    config = {
        extra = {
            prob = 5,
            prob_extra = 0,
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
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
    return { vars = {G.FUNCS.csau_add_chance(card.ability.extra.prob_extra, true, true), card.ability.extra.prob, card.ability.extra.prob_mod} }
end

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and context.before and not self.debuff then
        if context.scoring_name == "Flush" then
            if pseudorandom('flusher') < G.FUNCS.csau_add_chance(card.ability.extra.prob_extra, true) / card.ability.extra.prob then
                return {
                    card = card,
                    level_up = true,
                    message = localize('k_level_up_ex')
                }
            end
        end
    end
    if context.selling_card and not context.blueprint then
        if context.card.config.center.consumeable then
            card.ability.extra.prob_extra = card.ability.extra.prob_extra + 1
            G.E_MANAGER:add_event(Event({
                func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+"..card.ability.extra.prob_extra, colour = G.C.GREEN, instant = true}) return true
                end}
            ))
        end
    end
    if context.end_of_round and not context.blueprint and to_big(card.ability.extra.prob_extra) > to_big(0) then
        card.ability.extra.prob_extra = 0
        return {
            message = localize('k_reset'),
            colour = G.C.GREEN
        }
    end
end

return jokerInfo
	