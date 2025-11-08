local jokerInfo = {
    name = 'Granny Cream',
    config = {
        extra = {
            chip_goal = 150,
            chip_pool = 500,
        }
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    pools = { ["Food"] = true },
    streamer = "other",
    animated = {
        tiles = {
            x = 9,
            y = 4,
        },
    },
    artist = 'Crisppyboat'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.chip_goal, card.ability.extra.chip_pool } }
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main then
        if to_big(hand_chips) < to_big(card.ability.extra.chip_goal) then
            local spent_chips = to_big(card.ability.extra.chip_goal) - to_big(hand_chips)
            if to_big(spent_chips) > to_big(card.ability.extra.chip_pool) then
                spent_chips = to_big(card.ability.extra.chip_pool)
            end
            if SMODS.food_expires(context) then
                card.ability.extra.chip_pool = to_big(card.ability.extra.chip_pool) - to_big(spent_chips)
            end
            return {
                message = localize{type='variable',key='a_chips',vars={to_big(spent_chips)}},
                chip_mod = spent_chips
            }
        end
    end
    if context.cardarea == G.jokers and context.after and not (card.debuff or context.blueprint or context.repetition or context.individual or context.before) then
        if to_big(card.ability.extra.chip_pool) == to_big(0) then
            check_for_unlock({ type = "expire_grannycream" })
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 1, blockable = false,
                         func = function()
                             G.jokers:remove_card(card)
                             card:remove()
                             card = nil
                             return true
                         end
                    }))
                    return true
                end
            }))
            return {
                message = localize('k_sipped_ex'),
                colour = G.C.CHIPS
            }
        end
    end
end

return jokerInfo