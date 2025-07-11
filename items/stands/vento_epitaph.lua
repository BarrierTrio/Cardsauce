local consumInfo = {
    name = 'Epitaph',
    set = 'csau_Stand',
    config = {
        aura_colors = { 'fd5481DC', 'ee3c69DC' },
        aura_hover = true,
        evolve_key = 'c_csau_vento_epitaph_king',
        extra = {
            evolve_skips = 0,
            evolve_num = 3,
            preview = 1,
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    hasSoul = true,
    part = 'vento',
    blueprint_compat = false
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } }

    local main_end = nil
    if G.deck and not card.area.config.collection then
        main_end = G.FUNCS.csau_preview_cardarea(card.ability.extra.preview)
    end

    return {
        vars = {card.ability.extra.evolve_num - card.ability.extra.evolve_skips},
        main_end = main_end
    }
end

function consumInfo.in_pool(self, args)
    return (not G.GAME.used_jokers['c_csau_vento_epitaph_king'])
end

function consumInfo.calculate(self, card, context)
    if context.skip_blind and not context.blueprint and not context.retrigger_joker then
        card.ability.extra.evolve_skips = card.ability.extra.evolve_skips + 1
        if card.ability.extra.evolve_skips >= card.ability.extra.evolve_num then
            check_for_unlock({ type = "evolve_kingcrimson" })
            G.FUNCS.csau_evolve_stand(card)
        else
            return {
                no_retrigger = true,
                message = card.ability.extra.evolve_skips..'/'..card.ability.extra.evolve_num,
                colour = G.C.STAND
            }
        end
    end
end

return consumInfo