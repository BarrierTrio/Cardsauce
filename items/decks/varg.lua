local deckInfo = {
    name = 'Varg Deck',
    config = {},
    unlocked = false,
    discovered = false,
    config = { hand_size = -1 },
    unlock_condition = {type = 'win_deck', deck = 'b_checkered'},
    csau_dependencies = {
        'enableJoelContent',
    }
}

deckInfo.loc_vars = function(self, info_queue, card)
    if info_queue then
        info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku } }
    end
    return {vars = { self.config.hand_size } }
end

deckInfo.apply = function(self, back)
    G.E_MANAGER:add_event(Event({
        func = function()
            G.GAME.starting_params.csau_jokers_rate = G.GAME.starting_params.csau_jokers_rate or 1
            G.GAME.starting_params.csau_jokers_rate = G.GAME.starting_params.csau_jokers_rate * 2
            for k, v in pairs(G.GAME.probabilities) do
                G.GAME.probabilities[k] = v * 2
            end
            return true
        end
    }))
end

deckInfo.quip_filter = function(quip)
    return (quip and quip.csau_streamer and quip.csau_streamer == 'joel')
end

return deckInfo