local jokerInfo = {
    name = 'Live Dangerously',
    config = {
        extra = 1.5
    },
    rarity = 2,
    cost = 6,
    unlocked = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'BarrierTrio/Gote'
}

function jokerInfo.check_for_unlock(self, args)
    if args.type == "wheel_nope" then
        return true
    end
end

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra } }
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main and context.cardarea == G.jokers then
        return {
            xmult = card.ability.extra,
        }
    end

    if context.fix_probability then
        return {
            numerator = 0
        }
    end
end

return jokerInfo