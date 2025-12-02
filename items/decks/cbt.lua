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

deckInfo.loc_vars = function(self, info_queue, card)
    return {vars = { self.config.hands, self.config.discards } }
end

deckInfo.calculate = function(self, back, context)
    if context.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss and ArrowAPI.game.get_lowest_hand_level() > 1 then
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_all_hands'),chips = '...', mult = '...', level=''})
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            play_sound('tarot1')
            G.TAROT_INTERRUPT_PULSE = true
            return true end }))
        update_hand_text({delay = 0}, {mult = '-', StatusText = true})
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
            play_sound('tarot1')
            return true end }))
        update_hand_text({delay = 0}, {chips = '-', StatusText = true})
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
            play_sound('tarot1')
            G.TAROT_INTERRUPT_PULSE = nil
            return true end }))
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='1'})
        delay(1.3)
        for k, v in pairs(G.GAME.hands) do
            if to_big(v.level) > to_big(1) then
                level_up_hand(self, k, true, -1)
            end
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 1.8,
            blockable = false,
            func = (function()
                update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
                return true
            end)
        }))
    end
end

return deckInfo