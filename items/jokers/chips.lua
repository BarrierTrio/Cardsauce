local jokerInfo = {
    name = "Chips for Dinner",
    config = {
        extra = {
            chips = 80,
            chips_mod = 20,
        },
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    pools = { ["Food"] = true },
    has_shiny = true,
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'PaperMoon'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.chips, card.ability.extra.chips_mod } }
end

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and context.after and not (context.blueprint or card.debuff) and to_big(G.GAME.current_round.hands_left) == to_big(0) and SMODS.food_expires(context) then
        if to_big(card.ability.extra.chips - card.ability.extra.chips_mod) <= to_big(0) then
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
                message = localize('k_eaten_ex'),
                colour = G.C.CHIPS
            }
        else
            card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chips_mod
            return {
                message = localize{type='variable',key='a_chips_minus',vars={card.ability.extra.chips_mod}},
                colour = G.C.CHIPS
            }
        end
    end
    if to_big(card.ability.extra.chips) > to_big(0) and context.joker_main and context.cardarea == G.jokers and not card.debuff then
        return {
            chips = card.ability.extra.chips,
        }
    end
end

return jokerInfo