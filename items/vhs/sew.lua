local consumInfo = {
    name = 'Surviving Edged Weapons',
    key = 'sew',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        activated = false,
        destroyed = false,
        extra = {
            runtime = 4,
            uses = 0
        },
    },
    origin = {
        category = 'rlm',
        sub_origins = {
            'rlm_wotw',
        },
        custom_color = 'rlm'
    },
    artist = 'yunkie101'
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    return {
        vars = {
            card.ability.extra.runtime-card.ability.extra.uses,
            (card.ability.extra.runtime-card.ability.extra.uses) > 1 and 's' or ''
        }
    }
end

function consumInfo.can_use(self, card)
    if to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit) or card.area == G.consumeables then return true end
end

function consumInfo.calculate(self, card, context)
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

		card.ability.extra.uses = card.ability.extra.uses+1
		if card.ability.extra.uses >= card.ability.extra.runtime then
			G.FUNCS.destroy_tape(card)
			card.ability.destroyed = true
		else
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

--[[

THINGS AFFECTED BY SURVIVING EDGED WEAPONS MANUALLY (FUCK):

Vanilla:
- Ceremonial Dagger ✔️
- Madness ✔️
- Ankh ✔️
- Hex ✔️
Cardsauce:
- Kill Jester ✔️

]]--