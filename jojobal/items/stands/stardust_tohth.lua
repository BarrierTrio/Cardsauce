local consumInfo = {
    name = 'Tohth',
    set = 'Stand',
    config = {
        aura_colors = { '9d8f64DC' , 'b2a784DC' },
        aura_hover = true,
        extra = {
            preview = 3
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'stardust',
        },
        custom_color = 'stardust'
    },
    blueprint_compat = false,
    artist = 'BarrierTrio/Gote',
}

function consumInfo.loc_vars(self, info_queue, card)
    local main_end = nil
    if G.deck and not card.area.config.collection then
        main_end = G.UIDEF.preview_cardarea(card.ability.extra.preview)
    end

    return {
        vars = {card.ability.extra.preview},
        main_end = main_end
    }
end

return consumInfo