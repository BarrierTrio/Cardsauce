local blindInfo = {
    name = "The Tray",
    color = HEX('de423b'),
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    vars = {},
    debuff = {},
    boss = {min = 3, max = 10}
}

function blindInfo.modify_hand(self, cards, poker_hands, text, mult, hand_chips)
    if pseudorandom(pseudoseed('onequartertrayof')) < G.GAME.probabilities.normal/3 then
        self.triggered = true
        return math.max(math.floor(mult/3 + 0.5), 1), math.max(math.floor(hand_chips/3 + 0.5), 0), true
    end
    return mult, hand_chips, false
end

function blindInfo.loc_vars(self)
    return {vars = { G.GAME.probabilities.normal, 3 } }
end
function blindInfo.collection_loc_vars(self)
    return {vars = { G.GAME.probabilities.normal, 3 } }
end

function blindInfo.defeat(self)
    check_for_unlock({ type = "defeat_tray" })
end

return blindInfo