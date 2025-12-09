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
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'Gappie',
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {
        card.ability.money,
        localize(G.GAME.current_round.joeycastle.suit, 'suits_singular'),
        colours = {
            G.C.SUITS[G.GAME.current_round.joeycastle.suit]}
        }
    }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.pre_discard and #context.full_hand >= 5 then
        for i, v in ipairs(context.full_hand) do
            if not v:is_suit(G.GAME.current_round.joeycastle.suit) then
                return
            end
        end

        check_for_unlock({ type = "high_joeyscastle" })
    end


    if context.discard and context.other_card:is_suit(G.GAME.current_round.joeycastle.suit) then
        return {
            dollars = card.ability.extra.dollars,
        }
    end
end


return jokerInfo
