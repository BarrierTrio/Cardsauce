local consumInfo = {
    name = 'Tusk ACT3',
    set = 'csau_Stand',
    config = {
        aura_colors = { 'ff7dbcDC', '3855aeDC' },
        stand_mask = true,
        evolved = true,
        evolve_key = 'c_csau_steel_tusk_4',
        extra = {
            chips = 34,
            evolve_percent = 0.1,
            evolved = false,
        }
    },
    cost = 10,
    rarity = 'csau_EvolvedRarity',
    hasSoul = true,
    part = 'steel',
    blueprint_compat = true
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit_2", set = "Other", vars = { G.csau_team.wario, G.csau_team.cauthen } }
    return {vars = {card.ability.extra.chips, card.ability.extra.evolve_percent * 100}}
end

function consumInfo.in_pool(self, args)
    if G.GAME.used_jokers['c_csau_steel_tusk_1']
    or G.GAME.used_jokers['c_csau_steel_tusk_2']
    or G.GAME.used_jokers['c_csau_steel_tusk_4'] then
        return false
    end
    
    return true
end

function consumInfo.calculate(self, card, context)
    if context.individual and context.cardarea == G.play and not card.debuff then
        if context.other_card:get_id() == 14 or context.other_card:get_id() == 2 or context.other_card:get_id() == 3 or context.other_card:get_id() == 5 then
            local flare_card = context.blueprint_card or card
            return {
                func = function()
                    G.FUNCS.csau_flare_stand_aura(flare_card, 0.50)
                end,
                extra = {
                    chips = card.ability.extra.chips,
                    card = flare_card
                }
            }
        end
    end

    local bad_context = context.repetition or context.blueprint or context.individual or context.retrigger_joker
    if context.end_of_round and not card.debuff and not bad_context then
        if to_big(G.GAME.chips) <= to_big(G.GAME.blind.chips * (1+card.ability.extra.evolve_percent)) and not card.ability.extra.evolved then
            card.ability.extra.evolved = true
            G.E_MANAGER:add_event(Event({
                func = (function()
                    check_for_unlock({ type = "evolve_tusk" })
                    G.FUNCS.evolve_stand(card)
                    return true
                end)
            }))
        end
    end
end


return consumInfo