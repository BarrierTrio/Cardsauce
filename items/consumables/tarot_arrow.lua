local consumInfo = {
    key = 'c_csau_tarot_arrow',
    name = 'The Arrow',
    set = 'Tarot',
    cost = 3,
    alerted = true,
    part = 'diamond',
    csau_dependencies = {
        'enableStands',
    }
}

function consumInfo.loc_vars(self, info_queue, card)
    if G.GAME and G.GAME.modifiers.csau_unlimited_stands then
        info_queue[#info_queue+1] = {key = "csau_stand_info_unlimited", set = "Other"}
    else
        if card.area then
            info_queue[#info_queue+1] = {key = "csau_stand_info", set = "Other", vars = { G.GAME and G.GAME.modifiers.max_stands or 1, (card.area.config.collection and localize('k_csau_stand')) or (G.GAME.modifiers.max_stands > 1 and localize('b_csau_stand_cards') or localize('k_csau_stand')) }}
        end
    end
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } }
end

function consumInfo.use(self, card, area, copier)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
        play_sound('timpani')
        if next(SMODS.find_card("c_csau_vento_gold")) then
            local stand = SMODS.find_card("c_csau_vento_gold")[1]
            check_for_unlock({ type = "evolve_ger" })
            G.FUNCS.csau_evolve_stand(stand)
        else
            G.FUNCS.csau_new_stand(false)
        end
        return true
    end }))
    delay(0.6)
end

function consumInfo.can_use(self, card)
    if next(SMODS.find_card("c_csau_vento_gold")) then
        return true
    end
    
    if G.consumeables.config.card_limit <= #G.consumeables.cards - (card.area == G.consumeables and 1 or 0) then
        return false
    end

    return G.GAME.modifiers.csau_unlimited_stands or (to_big(G.FUNCS.csau_get_num_stands()) < to_big(G.GAME.modifiers.max_stands))
end

return consumInfo
