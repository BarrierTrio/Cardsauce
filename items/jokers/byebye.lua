local jokerInfo = {
    name = 'Bye-Bye, Norway',
    atlas = 'jokers',
	pos = {x = 2, y = 13},
    config = {
        extra = {
            dollars_mod = 4
        },
        csau_extra_value = 0,
    },
    rarity = 3,
    cost = 10,
    unlocked = false,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,
    has_shiny = true,
    unlock_condition = {type = 'win_deck', deck = 'b_abandoned'},
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
    artist = 'GuffNFluff'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.dollars_mod } }
end

function jokerInfo.check_for_unlock(self, args)
    if (args.type == "win_deck" and get_deck_win_stake(self.unlock_condition.deck)) then
        return true
    end
end

function jokerInfo.calculate(self, card, context)
    if context.hand_drawn or context.other_drawn then
        local faces = 0
        for i, v in ipairs(G.hand.cards) do
            if v:is_face() then
                faces = faces + 1
            end
        end
        card.ability.csau_extra_value = card.ability.extra.dollars_mod * faces
        card:set_cost()
    end

    if context.selling_self then
        local destroy_cards = {}
        for _, v in ipairs(G.hand.cards) do
            if v:is_face() and not v.csau_byebye_flagged then
                v.csau_byebye_flagged = true
                destroy_cards[#destroy_cards+1] = v
            end
        end

        SMODS.destroy_cards(destroy_cards)
    end
end

return jokerInfo
