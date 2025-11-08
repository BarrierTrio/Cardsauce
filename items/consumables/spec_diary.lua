local consumInfo = {
    name = 'The Diary',
    set = "Spectral",
    cost = 4,
    alerted = true,
    part = 'stone',
    csau_dependencies = {
        'enableStands',
    },
    artist = 'SagaciousCejai'
}

function consumInfo.loc_vars(self, info_queue, card)
    if G.GAME.modifiers.csau_unlimited_stands then
        info_queue[#info_queue+1] = {key = "stand_info_unlimited", set = "Other"}
    else
        info_queue[#info_queue+1] = {key = "stand_info", set = "Other", vars = { (G.GAME and G.GAME.modifiers.max_stands or 1), (card.area.config.collection and localize('k_stand')) or ((G.GAME and G.GAME.modifiers.max_stands or 1) > 1 and localize('b_stand_cards') or localize('k_stand')) }}
    end
end

function consumInfo.use(self, card, area, copier)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
        play_sound('timpani')
        G.FUNCS.csau_new_stand(true)
        return true
    end }))
    delay(0.6)
end

function consumInfo.can_use(self, card)
    if to_big(G.consumeables.config.card_limit) <= to_big(#G.consumeables.cards - (card.area == G.consumeables and 1 or 0)) then
        return false
    end

    return G.GAME.modifiers.csau_unlimited_stands or to_big(G.FUNCS.csau_get_num_stands()) < to_big(G.GAME.modifiers.max_stands)
end

return consumInfo