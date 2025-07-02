local consumInfo = {
    name = 'C-MOON',
    set = 'csau_Stand',
    config = {
        aura_colors = { '73b481DC', 'a3d88fDC' },
        stand_mask = true,
        evolved = true,
        evolve_key = 'c_csau_stone_white_heaven',
        extra = {
            repetitions = 1,
            evolve_moons = 0,
            evolve_num = 4,
            ranks = {}
        }
    },
    cost = 10,
    rarity = 'csau_EvolvedRarity',
    hasSoul = true,
    part = 'stone',
    blueprint_compat = true
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit_2", set = "Other", vars = { G.csau_team.wario, G.csau_team.gote } }
    return { 
        vars = {card.ability.extra.evolve_num - card.ability.extra.evolve_moons},
        key = self.key..(csau_config['detailedDescs'] and '_detailed' or '')
    }
end

function consumInfo.in_pool(self, args)
    if G.GAME.used_jokers['c_csau_stone_white']
    or G.GAME.used_jokers['c_csau_stone_white_heaven'] then
        return false
    end
    
    return true
end

function consumInfo.calculate(self, card, context)
    local bad_context = context.blueprint or context.retrigger_joker
    if context.using_consumeable and not card.debuff and not bad_context and context.consumeable.config.center.key == 'c_moon' then
        
        card.ability.extra.evolve_moons = card.ability.extra.evolve_moons + 1
        if card.ability.extra.evolve_moons >= card.ability.extra.evolve_num then
            G.FUNCS.evolve_stand(card)
            return
        end

        return {
            func = function()
                G.FUNCS.csau_flare_stand_aura(card, 0.5)
            end,
            extra = {
                message = localize{type='variable',key='a_remaining',vars={card.ability.extra.evolve_num - card.ability.extra.evolve_moons}},
                colour = G.C.STAND,
                delay = 1
            }
        }
    end

    if context.cardarea == G.play and context.repetition and not card.debuff then
        local reps = next(context.poker_hands["Straight"]) and 1 or 0
        if context.other_card:get_id() == 6 then reps = reps + 1 end
        
        if reps > 0 then
            local flare_card = context.blueprint_card or card       
            return {
                pre_func = function()
                    G.FUNCS.csau_flare_stand_aura(flare_card, 0.5)
                end,
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.repetitions * reps,
                card = context.other_card
            }
        end
    end
end


return consumInfo