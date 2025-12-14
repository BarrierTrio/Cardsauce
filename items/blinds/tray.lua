local blindInfo = {
    name = "The Tray",
    atlas = 'blinds',
    pos = {x = 0, y = 5},
    color = HEX('de423b'),
    dollars = 5,
    mult = 2,
    vars = {},
    debuff = {},
    boss = {min = 3, max = 10},
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
}

function blindInfo.modify_hand(self, cards, poker_hands, text, mult, hand_chips)
    if SMODS.pseudorandom_probability(G.GAME.blind, 'csau_tray', 1, 3) then
        self.triggered = true
        return math.max(math.floor(mult/3 + 0.5), 1), math.max(math.floor(hand_chips/3 + 0.5), 0), true
    end
    return mult, hand_chips, false
end

function blindInfo.loc_vars(self)
    return {vars = { SMODS.get_probability_vars(self, 1, 3, 'csau_tray') } }
end
function blindInfo.collection_loc_vars(self)
    return {vars = { SMODS.get_probability_vars(self, 1, 3, 'csau_tray') } }
end

function blindInfo.defeat(self)
    check_for_unlock({ type = "defeat_tray" })
end

return blindInfo