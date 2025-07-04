local consumInfo = {
    name = 'Tohth',
    set = 'csau_Stand',
    config = {
        aura_colors = { '9d8f64DC' , 'b2a784DC' },
        aura_hover = true,
        extra = {
            preview = 3
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    hasSoul = true,
    part = 'stardust',
    blueprint_compat = false,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } }

    local main_end = nil
    if G.deck and not card.area.config.collection then
        main_end = G.FUNCS.csau_preview_cardarea(card.ability.extra.preview)
    end

    return { 
        vars = {card.ability.extra.preview},
        main_end = main_end
    }
end

return consumInfo