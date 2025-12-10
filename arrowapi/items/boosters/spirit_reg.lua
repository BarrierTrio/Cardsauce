local packInfo = {
    name = 'Spirit Pack',
    atlas = 'arrow_boosters',
    pos = {x = 0, y = 1},
    prefix_config = {atlas = false},
    config = {
        extra = 2,
        choose = 1,
    },
    weight = 0.25,
    cost = 6,
    kind = 'Stand',
    group_key = "k_spirit_pack",
    select_card = 'consumeables',
    origin = 'jojo',
    requires_type = 'Stand',
    artist = 'yunkie101',
    programmer = 'Vivian Giacobbi',
}

function packInfo.loc_vars(self, info_queue, card)
    if G.GAME.modifiers.unlimited_stands then
        info_queue[#info_queue+1] = {key = "stand_info_unlimited", set = "Other"}
    else
        info_queue[#info_queue+1] = {key = "stand_info", set = "Other", vars = { G.GAME.modifiers.max_stands or 1, (card.area.config.collection and localize('k_stand')) or ((G.GAME.modifiers.max_stands or 1) > 1 and localize('b_stand_cards') or localize('k_stand')) }}
    end
    return { vars = {card.ability.choose, card.ability.extra} }
end

function packInfo.create_card(self, card)
    return {set = "Stand", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = 'stand1'}
end

function packInfo.ease_background_colour(self)
    ease_colour(G.C.DYN_UI.MAIN, G.C.STAND)
    ease_background_colour{new_colour = darken(G.C.STAND, 0.2), special_colour = G.C.STAND, contrast = 5}
end

function packInfo.particles(self)
    G.booster_pack_sparkles = Particles(1, 1, 0,0, {
        timer = 0.015,
        scale = 0.2,
        initialize = true,
        lifespan = 1,
        speed = 1.1,
        padding = -1,
        attach = G.ROOM_ATTACH,
        colours = {G.C.WHITE, lighten(G.C.STAND, 0.4), lighten(G.C.STAND, 0.2), lighten(G.C.PURPLE, 0.2)},
        fill = true
    })
    G.booster_pack_sparkles.fade_alpha = 1
    G.booster_pack_sparkles:fade(1, 0)
end

return packInfo