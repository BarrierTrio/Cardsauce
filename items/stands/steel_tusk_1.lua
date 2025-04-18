local consumInfo = {
    name = 'Tusk ACT1',
    set = 'csau_Stand',
    config = {
        evolve_key = 'c_csau_steel_tusk_2',
        extra = {
            chips = 20,
            evolve_scores = 0,
            evolve_num = 20,
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    part = 'steel',
    in_progress = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit_2", set = "Other", vars = { G.csau_team.wario, G.csau_team.cauthen } }
    return {vars = {card.ability.extra.chips, card.ability.extra.evolve_num - card.ability.extra.evolve_scores}}
end

function consumInfo.in_pool(self, args)
    if next(SMODS.find_card('j_showman')) then
        return true
    end

    if G.GAME.used_jokers['c_csau_steel_tusk_2']
    or G.GAME.used_jokers['c_csau_steel_tusk_3']
    or G.GAME.used_jokers['c_csau_steel_tusk_4'] then
        return false
    end
    
    return true
end

function consumInfo.calculate(self, card, context)
    if context.individual and context.cardarea == G.play and not card.debuff and not context.repetition then
        if context.other_card:get_id() == 14 or context.other_card:get_id() == 2 then
            card.ability.extra.evolve_scores = card.ability.extra.evolve_scores + 1
            send(card.ability.extra.evolve_scores)
            if card.ability.extra.evolve_scores >= card.ability.extra.evolve_num then
                if not context.blueprint then
                    G.FUNCS.csau_evolve_stand(card)
                end
            else
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
    end
end

function consumInfo.can_use(self, card)
    return false
end

return consumInfo