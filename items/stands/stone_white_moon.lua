local consumInfo = {
    name = 'C-MOON',
    set = 'Stand',
    config = {
        aura_colors = { '73b481DC', 'a3d88fDC' },
        stand_mask = true,
        evolved = true,
        evolve_key = 'c_jojobal_stone_white_heaven',
        extra = {
            repetitions = 1,
            evolve_moons = 0,
            evolve_num = 4,
            ranks = {}
        }
    },
    cost = 10,
    rarity = 'EvolvedRarity',
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'stone',
        },
        custom_color = 'stone'
    },
    blueprint_compat = true,
    artist = {'wario', 'gote'}
}

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.evolve_num - card.ability.extra.evolve_moons}}
end

function consumInfo.in_pool(self, args)
    if G.GAME.used_jokers['c_jojobal_stone_white']
    or G.GAME.used_jokers['c_jojobal_stone_white_heaven'] then
        return false
    end
    
    return true
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.using_consumeable and not context.blueprint and not context.retrigger_joker and context.consumeable.config.center.key == 'c_moon' then
        card.ability.extra.evolve_moons = card.ability.extra.evolve_moons + 1
        if card.ability.extra.evolve_moons >= card.ability.extra.evolve_num then
            ArrowAPI.stands.evolve_stand(card)
        else 
            return {
                no_retrigger = true,
                func = function()
                    ArrowAPI.stands.flare_aura(card, 0.5)
                end,
                extra = {
                    message = localize{type='variable',key='a_remaining',vars={card.ability.extra.evolve_num - card.ability.extra.evolve_moons}},
                    colour = G.C.STAND,
                    delay = 1
                }
            }
        end
    end

    if context.cardarea == G.play and context.repetition then
        local reps = next(context.poker_hands["Straight"]) and 1 or 0
        if context.other_card:get_id() == 6 then reps = reps + 1 end
        
        if reps > 0 then
            local flare_card = context.blueprint_card or card
            return {
                pre_func = function()
                    ArrowAPI.stands.flare_aura(flare_card, 0.5)
                end,
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.repetitions * reps,
                card = flare_card
            }
        end
    end
end


return consumInfo