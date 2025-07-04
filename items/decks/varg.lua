local deckInfo = {
    name = 'Varg Deck',
    unlocked = false,
    discovered = false,
    config = { 
        hand_size = -1,
        probability_mod = 2
    },
    unlock_condition = {type = 'win_deck', deck = 'b_checkered'},
    csau_dependencies = {
        'enableJoelContent',
    }
}

function deckInfo.loc_vars(self, info_queue, card)
    if info_queue then
        info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku } }
    end
    return {vars = { self.config.hand_size } }
end

function deckInfo.apply(self, back)
    G.E_MANAGER:add_event(Event({
        func = function()
            G.GAME.starting_params.csau_jokers_rate = G.GAME.starting_params.csau_jokers_rate or 1
            G.GAME.starting_params.csau_jokers_rate = G.GAME.starting_params.csau_jokers_rate * 2
            return true
        end
    }))
end

function deckInfo.calculate(self, back, context)
    if context.mod_probability then
        return {
            numerator = context.numerator * 2
        }
    end
end

return deckInfo