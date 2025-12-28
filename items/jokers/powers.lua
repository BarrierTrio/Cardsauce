local jokerInfo = {
    name = 'Live Dangerously',
    atlas = 'jokers',
	pos = {x = 2, y = 15},
    config = {
        extra = 1.5
    },
    rarity = 2,
    cost = 6,
    unlocked = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
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
    artist = 'BarrierTrio/Gote'
}

function jokerInfo.check_for_unlock(self, args)
    return args.type == "wheel_nope"
end

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra } }
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main then
        return {
            x_mult = card.ability.extra,
        }
    end

    if context.fix_probability then
        return {
            numerator = 0
        }
    end
end

return jokerInfo