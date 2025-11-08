local jokerInfo = {
    name = 'Mug',
    config = {
        extra = {
            form = 'mug',
            mult = 1,
            mult_xmod = 2,
            x_mult = 6,
            rounds = 5,
        }
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    pixel_size = { w = 71, h = 73 },
    pools = { ["Food"] = true },
    hasSoul = true,
    streamer = "joel",
    artist = 'SagaciousCejai'
}

local forms = {
    ["mug"] = {
        name = 'mug',
        pos = { x = 1, y = 0 },
        pixel_size = { w = 71, h = 73 },
        soul_pos = { x = 2, y = 0},
    },
    ["moment"] = {
        name = 'moment',
        pos = { x = 1, y = 1},
        pixel_size = { w = 71, h = 95},
        soul_pos = { x = 2, y = 1},
    },
}

local change_form = function(card, form)
    if forms[form] then
        card.ability.extra.form = forms[form].name
        card.config.center.pos = forms[form].pos
        card.config.center.pixel_size = forms[form].pixel_size
        card.config.center.soul_pos = forms[form].soul_pos
    else
        for k, v in pairs(forms) do
            if v.name == form then
                card.ability.extra.form = v.name
                card.config.center.pos = v.pos
                card.config.center.pixel_size = v.pixel_size
                card.config.center.soul_pos = v.soul_pos
            end
        end
    end

    card.T.w = G.CARD_W
    card.T.h = G.CARD_H
    card:set_sprites(card.config.center)
    card.config.center.pos = forms.mug.pos
    card.config.center.pixel_size = forms.mug.pixel_size
    card.config.center.soul_pos = forms.mug.soul_pos

    return card.ability.extra.form
end

function jokerInfo.loc_vars(self, info_queue, card)
    return {
        vars = { card.ability.extra.mult, card.ability.extra.rounds, card.ability.extra.x_mult },
        key = "j_csau_mug_"..card.ability.extra.form
    }
end

function jokerInfo.set_sprites(self, card, _front)
    if card.config.center.discovered or card.bypass_discovery_center then
        card.children.center:reset()
    end
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main and context.cardarea == G.jokers then
        if card.ability.extra.form == "mug" then
            return {
                mult = card.ability.extra.mult,
            }
        elseif card.ability.extra.form == "moment" then
            return {
                xmult = card.ability.extra.x_mult,
            }
        end
    end
    if context.end_of_round and not context.other_card then
        if card.ability.extra.form == "moment" and SMODS.food_expires(context) then
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
                message = localize('k_mug_gone'),
                colour = G.C.FILTER
            }
        elseif card.ability.extra.form == "mug" then
            card.ability.extra.mult = card.ability.extra.mult * 2
            card.ability.extra.rounds = card.ability.extra.rounds - 1
            if to_big(card.ability.extra.rounds) <= to_big(0) then
                check_for_unlock({ type = "activate_mug" })
                change_form(card, "moment")
                card:juice_up(1, 1)
                return {
                    message = localize('k_mug_moment'),
                    colour = G.C.MUG
                }
            else
                return {
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                    colour = G.C.MULT
                }
            end
        end
    end
end

function jokerInfo.update(self, card)
    if G.screenwipe and card.ability.extra.form == 'moment' then
        change_form(card, 'moment')
    end
end

return jokerInfo