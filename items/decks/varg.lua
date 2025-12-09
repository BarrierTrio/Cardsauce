local deckInfo = {
    name = 'Varg Deck',
    unlocked = false,
    discovered = false,
    config = {
        hand_size = -1,
        probability_mod = 2
    },
    unlock_condition = {type = 'win_deck', deck = 'b_checkered'},
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'Kekulism',
}

function deckInfo.loc_vars(self, info_queue, card)
    return {vars = { self.config.hand_size } }
end

function deckInfo.apply(self, back)
    G.GAME.starting_params.csau_jokers_rate = (G.GAME.starting_params.csau_jokers_rate or 1) * 2
end

function deckInfo.calculate(self, back, context)
    if context.mod_probability then
        return {
            numerator = context.numerator * self.config.probability_mod
        }
    end
end

return deckInfo