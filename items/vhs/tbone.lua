local vanilla_rarities = {
    'common',
    'uncommon',
    'rare',
    'legendary'
}

local consumInfo = {
    name = "T-Bone's World of Clowning",
    atlas = 'vhs',
	pos = {x = 5, y = 2},
    set = "VHS",
    runtime = 3,
    cost = 6,
    config = {
        extra = {
            mult = {
                [1] = 12,
                [2] = 8,
                [3] = 4
            },
        },
    },
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'vinny',
            'vinny_wotw',
        },
        custom_color = 'vinny'
    },
    artist = 'Gongalicious'
}

function consumInfo.loc_vars(self, info_queue, card)
    return {
        vars = {
            localize('k_'..vanilla_rarities[1]),
            card.ability.extra.mult[1],
            localize('k_'..vanilla_rarities[2]),
            card.ability.extra.mult[2],
            localize('k_'..vanilla_rarities[3]),
            card.ability.extra.mult[3],
            colours = {
                G.C.RARITY[1],
                G.C.RARITY[2],
                G.C.RARITY[3]
            }
        }
    }
end

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.other_joker then
        local mult = card.ability.extra.mult[context.other_joker.config.center.rarity] or 0
        if mult <= 0 then return end

        G.E_MANAGER:add_event(Event({
            func = function()
                context.other_joker:juice_up(0.5, 0.5)
                return true
            end
        }))

        return {
            mult = mult,
            card = context.blueprint_card or card
        }
    end

    if context.end_of_round and context.main_eval and card.ability.activated and not context.blueprint then
       ArrowAPI.vhs.run_tape(card)
    end
end

return consumInfo