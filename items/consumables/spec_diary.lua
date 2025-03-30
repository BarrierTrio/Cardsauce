local consumInfo = {
    name = 'The Diary',
    set = "Spectral",
    cost = 4,
    alerted = true,
    part = 'stone'
}

function consumInfo.loc_vars(self, info_queue, card)
    if G.GAME.unlimited_stands then
        info_queue[#info_queue+1] = {key = "stand_info_unlimited", set = "Other"}
    else
        info_queue[#info_queue+1] = {key = "stand_info", set = "Other", vars = { G.GAME.max_stands or 1, (card.area.config.collection and localize('k_stand')) or (G.GAME.max_stands > 1 and localize('b_stand_cards') or localize('k_stand')) }}
    end

    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.cejai } }
end

function consumInfo.use(self, card, area, copier)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
        play_sound('timpani')
        G.FUNCS.new_stand(true)
        return true
    end }))
    delay(0.6)
end

function consumInfo.can_use(self, card)
    if G.GAME.unlimited_stands then
        return G.consumeables.config.card_limit > #G.consumeables.cards - (card.area == G.consumeables and 1 or 0)
    end

    return G.FUNCS.get_num_stands() < G.GAME.max_stands
end

return consumInfo