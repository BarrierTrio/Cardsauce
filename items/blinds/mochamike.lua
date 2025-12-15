local blindInfo = {
    name = "Mocha Mike",
    atlas = 'blinds',
    pos = {x = 0, y = 9},
    boss_colour = HEX('a07c64'),
    dollars = 8,
    mult = 2,
    vars = {},
    debuff = {},
    boss = {min = 1, max = 10, showdown = true}
}

function blindInfo.defeat(self)
    check_for_unlock({ type = "defeat_mochamike" })
end

function blindInfo.loc_vars(self)
    return {vars = { localize(G.GAME.current_round.most_played_poker_hand, 'poker_hands') or localize('ph_most_played') } }
end

function blindInfo.collection_loc_vars(self)
    return {vars = { localize('ph_most_played') } }
end

function blindInfo.debuff_hand(self, cards, hand, handname, check)
    return (not G.GAME.blind.disabled and handname == G.GAME.current_round.most_played_poker_hand)
end

return blindInfo