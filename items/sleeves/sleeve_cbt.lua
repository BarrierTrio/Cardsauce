local sleeveInfo = {
    name = 'CBT Sleeve',
    config = { max_money = 30 },
    unlocked = false,
    unlock_condition = { deck = "b_csau_cbt", stake = "stake_gold" },
    artist = 'BarrierTrio/Gote'
}

sleeveInfo.loc_vars = function(self, info_queue)
    local key, vars
    if self.get_current_deck_key() == "b_csau_cbt" then
        key = self.key .. "_alt"
        self.config = { joker_slot = -1, hands = -1, max_money = 30, no_interest = true, }
        vars = { self.config.joker_slot, self.config.hands, self.config.max_money }
    else
        key = self.key

        self.config = { discards = -1, hands = -1 }
        vars = { self.config.discards, self.config.hands }
    end
    return { key = key, vars = vars }
end

sleeveInfo.calculate = function(self, back, context)
    if context.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss and G.FUNCS.cbt_can_delevel() then
        if self.get_current_deck_key() ~= "b_csau_cbt" then
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
end

local ed_ref = ease_dollars
function ease_dollars(mod, instant)
    if CardSleeves and G.GAME.selected_sleeve then
        local sleeve_center = CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve)
        if sleeve_center.key == 'sleeve_csau_sleeve_cbt' and CardSleeves.Sleeve.get_current_deck_key() == "b_csau_cbt" then
            if sleeve_center.config.max_money then
                if G.GAME.dollars + mod > sleeve_center.config.max_money then
                    mod = sleeve_center.config.max_money - G.GAME.dollars
                    if mod < 0 then mod = 0 end
                end
            end
        end
    end
    return ed_ref(mod, instant)
end

return sleeveInfo