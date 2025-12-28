local blindInfo = {
    name = "The Finger",
    atlas = 'blinds',
    pos = {x = 0, y = 1},
    boss_colour = HEX('a88850'),
    dollars = 5,
    mult = 2,
    vars = {},
    debuff = { },
    boss = {min = 1, max = 10},
}

function blindInfo.defeat(self)
    check_for_unlock({ type = "defeat_finger" })
end

function blindInfo.debuff_hand(self, cards, hand, handname, check)
    return (not G.GAME.blind.disabled and handname == "High Card")
end

return blindInfo