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
    streamer = "joel",
    artist = 'Gappie',
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.money, localize(G.GAME.current_round.joeycastle.suit, 'suits_singular'), colours = {G.C.SUITS[G.GAME.current_round.joeycastle.suit]} }}
end

function jokerInfo.calculate(self, card, context)
    if context.pre_discard then
        card.ability.extra.ach_disc = 0
    end

    if card.debuff then return end

    if context.discard and not context.other_card.debuff and context.other_card:is_suit(G.GAME.current_round.joeycastle.suit) then
        card.ability.extra.ach_disc = card.ability.extra.ach_disc + 1
        if to_big(card.ability.extra.ach_disc) >= to_big(5) then
            check_for_unlock({ type = "high_joeyscastle" })
        end
        return {
            dollars = card.ability.extra.dollars,
        }
    end
end


return jokerInfo
