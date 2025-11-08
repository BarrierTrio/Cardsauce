local jokerInfo = {
    name = 'Nutbuster',
    config = {
        extra = {
            numerator = 3,
            denominator = 4,
        }
    },
    rarity = 1,
    cost = 4,
    unlocked = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "joel",
    artist = 'BarrierTrio/Gote'
}

SMODS.Sound({
    key = "doot",
    path = "doot.ogg",
})

function jokerInfo.check_for_unlock(self, args)
    if args.type == "wheel_trigger" then
        return true
    end
end

function jokerInfo.calculate(self, card, context)
    if context.blueprint or card.debuff then return end

    if context.fix_probability and context.trigger_obj and context.trigger_obj.config
    and context.trigger_obj.config.center and context.trigger_obj.config.center.key == 'c_wheel_of_fortune' then
        return {
            numerator = card.ability.extra.numerator,
            denominator = card.ability.extra.denominator
        }
    end
end

return jokerInfo