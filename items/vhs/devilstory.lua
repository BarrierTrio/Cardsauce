local consumInfo = {
    name = 'Devil Story',
    atlas = 'vhs',
	pos = {x = 3, y = 2},
    set = "VHS",
    runtime = 10,
    cost = 3,
    config = {
        extra = {
            dollars = 3,
            ach_enhancement = 'm_gold',
            ach_count = 5
        },
    },
    origin = {
        category = 'rlm',
        sub_origins = {
            'rlm_botw',
        },
        custom_color = 'rlm'
    },
    artist = 'Gongalicious'
}


function consumInfo.loc_vars(self, info_queue, card)
    return {
        vars = {
            card.ability.extra.dollars,
        }
    }
end

function consumInfo.calculate(self, card, context)
    if card.debuff or not card.ability.activated then return end

    if not context.blueprint and context.before and #context.scoring_hand >= card.ability.extra.ach_count then
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

    if not card.ability.destroyed and context.individual and context.cardarea == G.play
    and next(SMODS.get_enhancements(context.other_card)) then
        if not context.blueprint then
            ArrowAPI.vhs.run_tape(card)
        end
        return {
            dollars = card.ability.extra.dollars,
            card = context.blueprint_card or card
        }
    end
end

return consumInfo