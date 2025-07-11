local consumInfo = {
    name = 'Devil Story',
    key = 'devilstory',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        activated = false,
        destroyed = false,
        extra = {
            dollars = 3,
            runtime = 10,
            uses = 0,
            ach_enhancement = 'm_gold',
            ach_count = 5
        },
    },
    origin = {
        'rlm',
        'rlm_botw',
        color = 'rlm'
    }
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gong } }
    return { 
        vars = {
            card.ability.extra.dollars,
            card.ability.extra.runtime-card.ability.extra.uses
        }
    }
end

function consumInfo.calculate(self, card, context)
    if card.debuff or context.blueprint or not card.ability.activated then return end

    if context.before and #context.scoring_hand >= card.ability.extra.ach_count then
        local ach = 0
        for _, v in ipairs(context.scoring_hand) do
            local enhancements = SMODS.get_enhancements(v)
            if enhancements[card.ability.extra.ach_enhancement] then
                ach = ach + 1
            end
        end

        if ach >= card.ability.extra.ach_count then
            check_for_unlock({ type = 'high_horse' })
        end
    end

    if to_big(card.ability.extra.uses) < to_big(card.ability.extra.runtime) and context.individual
    and context.cardarea == G.play and next(SMODS.get_enhancements(context.other_card)) then
        card.ability.extra.uses = math.max(0, card.ability.extra.uses + 1)
        return {
            dollars = card.ability.extra.dollars,
            func = function()
                if to_big(card.ability.extra.uses) >= to_big(card.ability.extra.runtime) then
                    G.FUNCS.destroy_tape(card)
                    card.ability.destroyed = true
                end
            end
        }
    end
end

function consumInfo.can_use(self, card)
    if to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit) or card.area == G.consumeables then return true end
end

return consumInfo