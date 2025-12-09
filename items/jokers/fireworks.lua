local jokerInfo = {
    name = "Stolen Christmas",
    atlas = 'jokers',
	pos = {x = 6, y = 12},
    config = {
        extra = {
            fingers = 10,
        },
        activated = false,
    },
    rarity = 2,
    cost = 7,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'SagaciousCejai'
}

function jokerInfo.loc_vars(self, info_queue, card)
    local four_fingers = SMODS.four_fingers()
    if not ArrowAPI.current_config['enabled_DetailedDescs'] then
        info_queue[#info_queue+1] = {key = "rogernote", set = "Other", vars = {four_fingers and 4 or 5}}
        return {
            vars = { math.ceil(card.ability.extra.fingers / (four_fingers and 4 or 5)) }
        }
    end

    return {
        vars = { card.ability.extra.fingers },
    }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff or context.blueprint or context.joker_retrigger then return end

    if context.destroy_card and context.cardarea == G.play then
        card.ability.extra.fingers = math.max(0, card.ability.extra.fingers - (SMODS.four_fingers() and 4 or 5))

        if card.ability.extra.fingers > 0 then
             G.E_MANAGER:add_event(Event({
                trigger = 'after',
                func = function()
                    play_sound('whoosh2', math.random()*0.2 + 0.9,0.5)
                    play_sound('crumple'..math.random(1, 5), math.random()*0.2 + 0.9,0.5)
                    return true
                end
            }))
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_remaining',vars={card.ability.extra.fingers}},colour = G.C.IMPORTANT})
        else
            ArrowAPI.game.card_expire(card, 'k_allgone')
        end

        return {
            remove = true
        }
    end
end

return jokerInfo