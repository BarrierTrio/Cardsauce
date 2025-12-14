local deckInfo = {
    name = 'CBT Deck',
    atlas = 'decks',
    pos = {x = 3, y = 0},
    unlocked = false,
    discovered = false,
    config = { hands = -1, discards = -1 },
    unlock_condition = {type = 'win_stake', stake = 8},
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'joel',
        },
        custom_color = 'joel'
    },
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
    and ArrowAPI.game.get_hand_level_metric('lowest') > 1 then
        ArrowAPI.game.batch_level_up(self, G.handlist, 0)
    end
end

deckInfo.quip_filter = function(quip, q_type)
    return (quip and quip.csau_streamer and quip.csau_streamer == 'joel')
end

return deckInfo