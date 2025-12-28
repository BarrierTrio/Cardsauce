local jokerInfo = {
    name = 'Wigsaw',
    atlas = 'jokers',
	pos = {x = 4, y = 13},
    soul_pos = {x = 5, y = 13},
    config = {},
    rarity = 4,
    cost = 20,
    unlocked = false,
    unlock_condition = {type = '', extra = '', hidden = true},
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
    artist = 'BarrierTrio/Gote'
}

function jokerInfo.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    ArrowAPI.ui.generate_legendary_desc(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
end

return jokerInfo