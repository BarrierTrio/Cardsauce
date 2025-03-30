local jokerInfo = {
    name = 'Black Spine Junka',
    config = {
        extra = {
            mult_mod = 2,
            mult = 0,
            prob_mod = 1,
            prob_extra = 0,
            prob = 100,
        }
    },
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    streamer = "othervinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.yunkie } }
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.prob_mod, G.FUNCS.csau_add_chance(card.ability.extra.prob_extra, true), card.ability.extra.prob, card.ability.extra.mult } }
end

function jokerInfo.calculate(self, card, context)
    if context.vhs_death and not context.blueprint then
        if pseudorandom('junka') < G.FUNCS.csau_add_chance(card.ability.extra.prob_extra, true) / card.ability.extra.prob then
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                         func = function()
                             G.jokers:remove_card(card)
                             card:remove()
                             card = nil
                             return true; end}))
                    return true
                end
            }))
            return {
                message = localize('k_junka_lose')
            }
        else
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
            card.ability.extra.prob_extra = card.ability.extra.prob_extra + card.ability.extra.prob_mod
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}, delay = 0.4 })
        end
    end
    if context.joker_main and context.cardarea == G.jokers then
        if to_big(card.ability.extra.mult) > to_big(0) then
            return {
                mult = card.ability.extra.mult,
            }
        end
    end
end

return jokerInfo