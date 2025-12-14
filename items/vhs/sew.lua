local consumInfo = {
    name = 'Surviving Edged Weapons',
    atlas = 'vhs',
	pos = {x = 2, y = 0},
    set = "VHS",
    runtime = 4,
    cost = 3,
    blueprint_compat = false,
    config = {},
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'rlm',
            'rlm_wotw',
        },
        custom_color = 'rlm'
    },
    artist = 'yunkie101'
}

function consumInfo.calculate(self, card, context)
    if card.debuff or context.blueprint then return end

    if card.ability.activated and not card.ability.destroyed and context.check_eternal and context.other_card.ability.set == 'Joker'
    and not context.trigger.from_sell and SMODS.find_card('c_csau_sew')[1] == card then
        if context.trigger.config then
            if context.trigger.config.center.key == 'j_madness' then
                return
            elseif context.trigger.config.center.key == 'j_ceremonial' then
                -- fake ceremonial dagger behavior
                context.trigger.ability.mult = context.trigger.ability.mult + context.other_card.sell_cost*2
                G.E_MANAGER:add_event(Event({
                    func = function()
                        context.trigger:juice_up(0.8, 0.8)
                        play_sound('slice1', 0.96+math.random()*0.08)
                        return true
                    end
                }))
                card_eval_status_text(context.trigger, 'extra', nil, nil, nil, {
                    message = localize{type = 'variable',
                    key = 'a_mult',
                    vars = {context.trigger.ability.mult}},
                    colour = G.C.RED,
                    no_juice = true
                })
            end
        end

        G.E_MANAGER:add_event(Event({
            func = function()
                context.other_card:juice_up()
                return true
            end
        }))

        ArrowAPI.vhs.run_tape(card)
        if not card.ability.destroyed then
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = localize('k_survived'),
            })
        end

        return {
            no_destroy = true
        }
    end
end

return consumInfo