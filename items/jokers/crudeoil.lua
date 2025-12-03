local jokerInfo = {
    name = 'Crude Oil',
    atlas = 'jokers',
	pos = {x = 0, y = 9},
    config = {
        extra = {
            dollars = 8,
            dollars_mod = 2
        }
    },
    rarity = 1,
    cost = 8,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    has_shiny = true,
    pools = { ["Food"] = true },
    origin = 'vinny',
	dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'Lyzerus'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.dollars, card.ability.extra.dollars_mod } }
end

function jokerInfo.calc_dollar_bonus(self, card)
    if not card.debuff then
        return card.ability.extra.dollars
    end
end

function jokerInfo.calculate(self, card, context)
    if context.starting_shop and not context.blueprint then
        if SMODS.food_expires(card) then
            card.ability.extra.dollars = card.ability.extra.dollars - card.ability.extra.dollars_mod
            if card.ability.extra.dollars <= 0 then
                check_for_unlock({ type = "expire_crudeoil" })
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                             func = function()
                                 card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_drank_ex'), colour = G.C.MONEY})
                                 G.jokers:remove_card(card)
                                 card:remove()
                                 card = nil
                                 return true
                             end
                        }))
                        return true
                    end
                }))
            else
                return {
                    message = "-"..localize('$') .. card.ability.extra.dollars_mod,
                    colour = G.C.MONEY
                }
            end
        end
    end
end

return jokerInfo
