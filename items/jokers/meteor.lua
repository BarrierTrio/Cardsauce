local jokerInfo = {
    name = "Meteor",
    config = {
        extra = {
            id = 7,
        }
    },
    rarity = 1,
    cost = 5,
    unlocked = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "othervinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_glass
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.trance } }
end

function jokerInfo.check_for_unlock(self, args)
    if args.type == "roche_destroyed" then
        return true
    end
end

function jokerInfo.calculate(self, card, context)
    if context.check_enhancement and context.other_card.base.value == card.ability.extra.id and not context.other_card.config.center.key == 'm_glass' then
        return {
            ['m_glass'] = true
        }
    end

    if context.remove_playing_cards then
        local tally = 0
        for _, v in ipairs(context.removed) do
            if v.base.value == card.ability.extra.id and not v.config.center.key == 'm_glass' then
                tally = tally + 1
            end
        end
        
        if tally > 0 then
            check_for_unlock({type = 'destroy_meteor'})
        end
    end
end

return jokerInfo