local jokerInfo = {
    name = "Joey's Castle",
    atlas = 'jokers',
	pos = {x = 7, y = 7},
    config = {
        extra = {
            dollars = 1,
            ach_disc = 0
        }
    },
    rarity = 2,
    cost = 6,
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
    artist = 'Gappie',
}

function jokerInfo.loc_vars(self, info_queue, card)
    local suit = (G.GAME.current_round.joeycastle or {}).suit or 'Clubs'
    return { vars = {
        card.ability.extra.dollars,
        localize(suit, 'suits_singular'),
        colours = {
            G.C.SUITS[suit]}
        }
    }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.pre_discard and #context.full_hand >= 5 then
        local count = 0
        for i, v in ipairs(context.full_hand) do
            if v:is_suit(G.GAME.current_round.joeycastle.suit) then
                count = count + 1
            end
        end

        check_for_unlock({type = 'scale_card', card = card, ref_table = {count = count}, ref_value = 'count'})
    end


    if context.discard and context.other_card:is_suit(G.GAME.current_round.joeycastle.suit) then
        return {
            dollars = card.ability.extra.dollars,
        }
    end
end


return jokerInfo
