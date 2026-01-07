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

function jokerInfo.loc_vars(self, info_queue, card)
    return {
        vars = {G.GAME.wigsaw_suit},
        key = self.key..(G.GAME.wigsaw_suit and '_alt' or '')
    }
end

function jokerInfo.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    ArrowAPI.ui.generate_legendary_desc(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
end

function jokerInfo.add_to_deck(self, card, from_debuff)
    check_for_unlock({type = 'wigsaw_added'})
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    check_for_unlock({type = 'modify_deck'})
end

return jokerInfo