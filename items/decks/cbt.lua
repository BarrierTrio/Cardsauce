local deckInfo = {
    name = 'CBT Deck',
    unlocked = false,
    discovered = false,
    config = { hands = -1, discards = -1 },
    unlock_condition = {type = 'win_stake', stake = 8},
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'BarrierTrio/Gote'
}

function deckInfo.loc_vars(self, info_queue, card)
    return {vars = { self.config.hands, self.config.discards } }
end

function deckInfo.calculate(self, back, context)
    if context.end_of_round and G.GAME.blind:get_type() == 'Boss'
    and ArrowAPI.game.get_lowest_hand_level() > 1 then
        ArrowAPI.game.batch_level_up(self, G.handlist, 0)
    end
end

return deckInfo