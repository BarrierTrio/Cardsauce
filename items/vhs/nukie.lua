local consumInfo = {
    name = 'Nukie',
    key = 'nukie',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        activated = false,
        destroyed = false,
        extra = {
            runtime = 6,
            uses = 0,
            chance = 10
        }
    },
    origin = 'rlm',
    artist = 'MightyKingWario'
}


function consumInfo.loc_vars(self, info_queue, card)
    local num, _ =  SMODS.get_probability_vars(card, 1, 1, 'wheel_of_fortune')
	info_queue[#info_queue+1] = {key = "wheel2", set = "Other", vars = {num}}
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    local num2, dom = SMODS.get_probability_vars(self, 1, card.ability.extra.chance, 'csau_nukie_negative')
    return { vars = { num2, dom, card.ability.runtime-card.ability.uses } }
end

function consumInfo.calculate(self, card, context)
    if context.using_consumeable and context.consumeable.config.center.key == 'c_wheel_of_fortune'
    and card.ability.activated and ArrowAPI.vhs.find_activated_tape('c_csau_nukie') == card then
        card.ability.uses = card.ability.uses+1
        if to_big(card.ability.uses) >= to_big(card.ability.runtime) then
            ArrowAPI.vhs.destroy_tape(card)
            card.ability.destroyed = true
        else
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:juice_up()
                    play_sound('generic1')
                    return true
                end
            }))
        end
    end
end

function consumInfo.can_use(self, card)
    if to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit) or card.area == G.consumeables then return true end
end

return consumInfo