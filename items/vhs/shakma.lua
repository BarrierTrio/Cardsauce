local consumInfo = {
    name = 'Shakma',
    atlas = 'vhs',
	pos = {x = 3, y = 0},
    set = "VHS",
    runtime = 4,
    cost = 3,
    blueprint_compat = false,
    config = {},
    origin = {
        category = 'rlm',
        sub_origins = {
            'rlm_botw',
        },
        custom_color = 'rlm'
    },
    artist = 'Joey'
}

function consumInfo.calculate(self, card, context)
    if card.debuff or context.blueprint then return end

    if card.ability.activated and not card.ability.destroyed and context.fix_probability and ArrowAPI.vhs.find_activated_tape('c_csau_shakma') == card then
        if context.from_roll then
            ArrowAPI.vhs.run_tape(card)
        end

        return {
            message = context.from_roll and 'Guaranteed!' or nil,
            numerator = context.denominator,
            denominator = context.denominator,
        }
    end
end

return consumInfo