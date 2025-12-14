
local jokerInfo = {
    name = "UFO COMODIN",
    atlas = 'jokers',
	pos = {x = 1, y = 14},
    soul_pos = {x = 2, y = 14},
    config = {
        extra = {
            round_limit = 3,
            ufo_rounds = 0,
            rounds_mod = 1,
        },
        card_key = nil,
        card_ability = nil,
    },
    rarity = 3,
    cost = 9,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,
    no_soul_shadow = true,
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
    artist = {'BarrierTrio/Gote', 'elebant'}
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = G.P_TAGS.tag_negative

    local main_end = nil
    if card.ability.card_key then
        local name_text = localize{type = 'name_text', key = card.ability.card_key, set = 'Joker'}
        main_end = {
            {n=G.UIT.C, config={align = "bm", padding = 0.05}, nodes={
                {n=G.UIT.C, config={align = "m", colour = G.C.BLACK, r = 0.05, padding = 0.05}, nodes={{
                        n=G.UIT.T,
                        config={text = ' '..name_text..' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true}
                    }, {
                        n=G.UIT.T,
                        config={text = '[', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true}
                    }, {
                        n=G.UIT.T,
                        config={text = card.ability.ufo_rounds, colour = G.C.FILTER, scale = 0.3, shadow = true}
                    }, {
                        n=G.UIT.T,
                        config={text = '/'..card.ability.extra..'] ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true}
                    }
                }}
            }}
        }
    end

    return {
        vars = { card.ability.extra },
        main_end = main_end
    }
end

function jokerInfo.add_to_deck(self, card)
    local deletable_jokers = {}
    for k, v in pairs(G.jokers.cards) do
        if not v.ability.eternal then deletable_jokers[#deletable_jokers + 1] = v end
    end

    if #deletable_jokers > 0 then
        local _card =  pseudorandom_element(deletable_jokers, pseudoseed('ufo_choice'))
        card.ability.extra.card_key = _card.config.center.key
        card.ability.extra.card_ability = _card.ability
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.75,
            func = function()
                _card:start_dissolve()
                return true end
        }))
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_abducted')})
    end
end

function jokerInfo.calculate(self, card, context)
    if context.blueprint or card.debuff then
        return
    end

    if not card.ability.extra.card_key then
        if context.card_added and not context.card.ability.eternal then
            card.ability.extra.card_key = context.card.config.center.key
            card.ability.extra.card_ability = context.card.ability
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.75,
                func = function()
                    context.card:start_dissolve()
                    return true
                end
            }))

            return {
                message = localize('k_abducted')
            }
        end
    end

    if context.end_of_round and context.main_eval then
        SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = "ufo_rounds",
            scalar_value = "rounds_mod",
            scale_message = {
                message = (card.ability.extra.ufo_rounds < card.ability.extra.round_limit)
                and (card.ability.extra.ufo_rounds..'/'..card.ability.extra.round_limit) or localize('k_active_ex'),
                colour = G.C.DARK_EDITION
            }
        })

        if card.ability.ufo_rounds == card.ability.extra then
            local eval = function(condition_card) return not condition_card.REMOVED end
            juice_card_until(card, eval, true)
        end
    end

    if context.selling_self and (card.ability.extra.ufo_rounds >= card.ability.extra.extra) then
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_duplicated_ex')})
        local dropped_card = SMODS.create_card({ set = 'Joker', area = G.jokers, key = card.ability.extra.card_key, edition = 'e_negative' } )
        dropped_card.ability = card.ability.extra.card_ability
        dropped_card:start_materialize()
        dropped_card:add_to_deck()
        G.jokers:emplace(dropped_card)
    end
end

return jokerInfo