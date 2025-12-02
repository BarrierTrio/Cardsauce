local jokerInfo = {
    name = "Meteor",
    config = {
        extra = {
            key = '7',
        }
    },
    rarity = 1,
    cost = 5,
    unlocked = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'Global-Trance'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_glass
end

function jokerInfo.check_for_unlock(self, args)
    if args.type == "roche_destroyed" then
        return true
    end
end

function jokerInfo.calculate(self, card, context)
    if context.check_enhancement and context.other_card.base.value == card.ability.extra.key and context.other_card.config.center.key ~= 'm_glass' then
        return {
            ['m_glass'] = true
        }
    end

    if context.remove_playing_cards then
        local tally = 0
        for _, v in ipairs(context.removed) do
            if v.base.value == card.ability.extra.key and v.config.center.key ~= 'm_glass' then
                tally = tally + 1
            end
        end

        if tally > 0 then
            check_for_unlock({type = 'destroy_meteor'})
        end
    end
end

return jokerInfo