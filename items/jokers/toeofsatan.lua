local jokerInfo = {
    name = 'Toe of Satan',
    atlas = 'jokers',
	pos = {x = 7, y = 9},
    config = {
        extra = {
            discards = 3,
            discards_mod = 1
        }
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,
    has_shiny = true,
    pools = { ["Food"] = true },
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'PaperMoon'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return {vars = { card.ability.extra.discards, card.ability.extra.discards_mod } }
end

function jokerInfo.calculate(self, card, context)
    if context.setting_blind and not card.getting_sliced and not card.debuff and not context.blueprint then
        if not (context.blueprint_card or card).getting_sliced then
            G.E_MANAGER:add_event(Event({func = function()
                ease_discard(card.ability.extra.discards)
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_plus_discard', vars = {card.ability.extra.discards}, colour = G.C.RED}})
                return true
            end }))
        end
    end
    local bad_context = context.repetition or context.individual or context.blueprint
    if context.end_of_round and not bad_context then
        if SMODS.food_expires(context) then
            card.ability.extra.discards = card.ability.extra.discards - card.ability.extra.discards_mod
            if to_big(card.ability.extra.discards) > to_big(0) then
                return {
                    message = "-"..card.ability.extra.discards_mod,
                    colour = G.C.RED
                }
            else
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
                                 return true
                             end
                        }))
                        return true
                    end
                }))
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.FILTER
                }
            end
        end
    end
end

return jokerInfo