local jokerInfo = {
    name = "EAT IT",
    atlas = 'jokers',
	pos = {x = 8, y = 11},
    config = {
        extra = {
            chips_mod = 50,
            x_mult_mod = 0.5,
        },
    },
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
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
    artist = 'HunnyByte'
}

local function get_food()
    local food = 0
    for _, v in ipairs((G.jokers or {}).cards) do
        if ArrowAPI.table.contains(G.P_CENTER_POOLS.Food, v.config.center) then
            food = food + 1
        end
    end
    return food
end


function jokerInfo.loc_vars(self, info_queue, card)
    local num_food = get_food()
    return { vars = {
        card.ability.extra.chips_mod,
        card.ability.extra.x_mult_mod,
        card.ability.extra.chips_mod * num_food,
        1 + card.ability.extra.x_mult * num_food
    } }
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main then
        local num_food = get_food()
        return {
            chips = card.ability.extra.chips_mod * num_food,
            x_mult = 1 + card.ability.extra.x_mult * num_food,
        }
    end
end

return jokerInfo