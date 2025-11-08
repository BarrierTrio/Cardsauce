local packInfo = {
    name = 'Analog',
    alerted = true,
    config = {
        extra = 6,
        choose = 1,
    },
    weight = 0.5,
    cost = 6,
    kind = 'VHS',
    group_key = "k_jumbo_analog_pack",
    select_card = 'consumeables',
    csau_dependencies = {
        'enableVHSs',
    },
    origin = {
        'rlm',
        'rlm_wotw',
        color = 'rlm'
    },
    artist = 'yunkie101'
}

packInfo.loc_vars = function(self, info_queue, card)
    return { vars = {card.ability.choose, card.ability.extra} }
end

packInfo.create_card = function(self, card)
    return {set = "VHS", area = G.pack_cards, skip_materialize = true, soulable = false, key_append = "analog1"}
end

packInfo.ease_background_colour = function(self)
    ease_colour(G.C.DYN_UI.MAIN, G.C.VHS)
    ease_background_colour{new_colour = darken(G.C.VHS, 0.2), special_colour = G.C.VHS, contrast = 5}
end

packInfo.particles = function(self)
    G.booster_pack_sparkles = Particles(1, 1, 0,0, {
        timer = 0.015,
        scale = 0.2,
        initialize = true,
        lifespan = 1,
        speed = 1.1,
        padding = -1,
        attach = G.ROOM_ATTACH,
        colours = {G.C.WHITE, lighten(G.C.VHS, 0.4), lighten(G.C.VHS, 0.2), lighten(G.C.RED, 0.2)},
        fill = true
    })
    G.booster_pack_sparkles.fade_alpha = 1
    G.booster_pack_sparkles:fade(1, 0)
end

return packInfo