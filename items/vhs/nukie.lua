local consumInfo = {
    name = 'Nukie',
    atlas = 'vhs',
	pos = {x = 3, y = 1},
    set = "VHS",
    runtime = 6,
    cost = 3,
    blueprint_compat = false,
    config = {
        extra = {
            chance = 10
        }
    },
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'rlm',
        },
        custom_color = 'rlm'
    },
    artist = 'MightyKingWario'
}


function consumInfo.loc_vars(self, info_queue, card)
    local num, _ =  SMODS.get_probability_vars(card, 1, 1, 'wheel_of_fortune')
	info_queue[#info_queue+1] = {key = "wheel2", set = "Other", vars = {num}}
    local num2, dom = SMODS.get_probability_vars(self, 1, card.ability.extra.chance, 'csau_nukie_negative')
    return { vars = { num2, dom } }
end

function consumInfo.calculate(self, card, context)
    if card.debuff or context.blueprint then return end

    if context.using_consumeable and context.consumeable.config.center.key == 'c_wheel_of_fortune'
    and card.ability.activated and ArrowAPI.vhs.find_activated_tape('c_csau_nukie') == card then
        ArrowAPI.vhs.run_tape(card)

        if not card.ability.destroyed then
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

return consumInfo