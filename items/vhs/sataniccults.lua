local consumInfo = {
    name = 'Law Enforcement Guide to Satanic Cults',
    set = "VHS",
    atlas = 'vhs',
	pos = {x = 4, y = 1},
    runtime = 3,
    cost = 3,
    config = {
        extra = {
            x_mult = 2,
        }
    },
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'rlm',
            'rlm_wotw',
        },
        custom_color = 'rlm'
    },
    artist = 'Kekulism',
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_gold
    return { vars = { card.ability.extra.x_mult } }
end

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.individual and context.cardarea == G.hand
    and not context.end_of_round and SMODS.has_enhancement(context.other_card, 'm_gold')then
        return {
            x_mult = card.ability.extra.x_mult
        }
    end

    if context.after and card.ability.activated and not context.blueprint then
        ArrowAPI.vhs.run_tape(card)
    end
end

return consumInfo