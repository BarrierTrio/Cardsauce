local consumInfo = {
    name = 'The Arrow',
    set = 'Tarot',
    atlas = 'arrow_tarots',
    pos = {x = 2, y = 2},
    prefix_config = {atlas = false},
    cost = 3,
    alerted = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'diamond',
        },
        custom_color = 'diamond',
    },
    artist = 'BarrierTrio/Gote',
    programmer = 'Vivian Giacobbi',
    requires_type = 'Stand',
}

function consumInfo.in_pool(self, args)
    return ArrowAPI.loading.consumeable_has_items('Stand')
end

function consumInfo.loc_vars(self, info_queue, card)
    if G.GAME and G.GAME.modifiers.unlimited_stands then
        info_queue[#info_queue+1] = {key = "stand_info_unlimited", set = "Other"}
    else
        if card.area then
            info_queue[#info_queue+1] = {key = "stand_info", set = "Other", vars = { G.GAME and G.GAME.modifiers.max_stands or 1, (card.area.config.collection and localize('k_stand')) or ((G.GAME.modifiers.max_stands or 1) > 1 and localize('b_stand_cards') or localize('k_stand')) }}
        end
    end
end

function consumInfo.use(self, card, area, copier)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
        play_sound('timpani')
        if next(SMODS.find_card("c_jojobal_vento_gold")) then
            local stand = SMODS.find_card("c_jojobal_vento_gold")[1]
            check_for_unlock({ type = "evolve_ger" })
            ArrowAPI.stands.evolve_stand(stand)
        else
            ArrowAPI.stands.new_stand(false)
        end
        return true
    end }))
    delay(0.6)
end

function consumInfo.can_use(self, card)
    if G.consumeables.config.card_limit <= #G.consumeables.cards - (card.area == G.consumeables and 1 or 0) then
        return false
    end

    return G.GAME.modifiers.unlimited_stands or (ArrowAPI.stands.get_num_stands() < to_big(G.GAME.modifiers.max_stands)) or next(SMODS.find_card("c_jojobal_vento_gold"))
end

return consumInfo