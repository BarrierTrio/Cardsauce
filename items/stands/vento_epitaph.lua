local consumInfo = {
    name = 'Epitaph',
    set = 'Stand',
    config = {
        aura_colors = { 'fd5481DC', 'ee3c69DC' },
        aura_hover = true,
        evolve_key = 'c_jojobal_vento_epitaph_king',
        extra = {
            evolve_skips = 0,
            evolve_num = 3,
            preview = 1,
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'vento',
        },
        custom_color = 'vento'
    },
    blueprint_compat = false,
    artist = 'gote',
}

function consumInfo.loc_vars(self, info_queue, card)
    local main_end = nil
    if G.deck and not card.area.config.collection then
        main_end = G.UIDEF.preview_cardarea(card.ability.extra.preview)
    end

    return {
        vars = {card.ability.extra.evolve_num - card.ability.extra.evolve_skips},
        main_end = main_end
    }
end

function consumInfo.in_pool(self, args)
    return (not G.GAME.used_jokers['c_jojobal_vento_epitaph_king'])
end

function consumInfo.calculate(self, card, context)
    if context.skip_blind and not context.blueprint and not context.retrigger_joker then
        card.ability.extra.evolve_skips = card.ability.extra.evolve_skips + 1
        if card.ability.extra.evolve_skips >= card.ability.extra.evolve_num then
            check_for_unlock({ type = "evolve_kingcrimson" })
            ArrowAPI.stands.evolve_stand(card)
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