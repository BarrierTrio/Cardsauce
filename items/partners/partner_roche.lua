local partnerInfo = {
    name = "Roche Partner",
    unlocked = false,
    discovered = true,
    config = {
        extra = {
            related_card = "j_csau_roche",
        }
    },
    dependencies = {
        mods = {'partner'}
    },
    artist = 'BarrierTrio/Gote'
}

partnerInfo.loc_vars = function(self, info_queue, card)
    local word = next(SMODS.find_card(card.ability.extra.related_card)) and localize('b_next_round_2') or localize('k_ante')
    return { vars = { word } }
end

partnerInfo.check_for_unlock = function(self, args)
    for _, v in pairs(G.P_CENTER_POOLS["Joker"]) do
        if v.key == self.config.extra.related_card then
            if ArrowAPI.stands.get_win_sticker(v, true) >= 8 then
                return true
            end
            break
        end
    end
end

partnerInfo.calculate = function(self, card, context)
    if context.partner_setting_blind and not card.ability.locked then
        local eval = function(card) return not card.ability.locked end
        juice_card_until(card, eval, true)
    end
    if context.partner_before and G.GAME.current_round.hands_played == 0 and not card.ability.locked then
        card.ability.locked = true
        return {
            card = card,
            level_up = true,
            message = localize('k_level_up_ex')
        }
    end
    if next(SMODS.find_card(card.ability.extra.related_card)) then
        local bad_context = context.repetition or context.individual or context.blueprint
        if context.partner_end_of_round and not card.debuff and not bad_context then
            card.ability.locked = false
        end
    else
        local bad_context = context.repetition or context.individual or context.blueprint
        if context.partner_end_of_round and G.GAME.blind.boss and not card.debuff and not bad_context then
            card.ability.locked = false
        end
    end
end

return partnerInfo