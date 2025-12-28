local sleeveInfo = {
    name = 'CBT Sleeve',
    atlas = 'sleeves',
    pos = {x = 3, y = 0},
    config = { max_money = 30 },
    unlocked = false,
    unlock_condition = { deck = "b_csau_cbt", stake = "stake_gold" },
    artist = 'BarrierTrio/Gote'
}

function sleeveInfo.loc_vars(self, info_queue)
    local key = self.key
    local vars
    if self.get_current_deck_key() == "b_csau_cbt" then
        key = key.."_alt"
        vars = { -1, -1, 30 }
    else
        vars = { -1, -1 }
    end
    return { key = key, vars = vars }
end

function sleeveInfo.apply(self, sleeve)
    if self.get_current_deck_key() == "b_csau_cbt" then
        self.config = { joker_slot = -1, hands = -1, max_money = 30, no_interest = true, }
    else
        self.config = { discards = -1, hands = -1 }
    end
    CardSleeves.Sleeve.apply(sleeve)
end

function sleeveInfo.calculate(self, back, context)
    if context.end_of_round and G.GAME.blind:get_type() == 'Boss'
    and ArrowAPI.game.get_hand_level_metric('lowest') > 1
    and self.get_current_deck_key() ~= "b_csau_cbt" then
        ArrowAPI.game.batch_level_up(self, G.handlist, 0)
    end

    if context.money_altered and self.get_current_deck_key() ~= "b_csau_cbt" then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                G.GAME.dollars = math.min(G.GAME.dollars, self.config.max_money)
                return true
            end
        }))
    end
end

return sleeveInfo