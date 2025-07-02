local consumInfo = {
    name = 'Tusk ACT1',
    set = 'csau_Stand',
    config = {
        aura_colors = { 'ff7dbcDC', 'e675c2DC' },
        evolve_key = 'c_csau_steel_tusk_2',
        extra = {
            chips = 13,
            evolve_scores = 0,
            evolve_num = 20,
            evolved = false,
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    hasSoul = true,
    part = 'steel',
    blueprint_compat = true
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit_2", set = "Other", vars = { G.csau_team.wario, G.csau_team.cauthen } }
    return {vars = {card.ability.extra.chips, card.ability.extra.evolve_num - card.ability.extra.evolve_scores}}
end

function consumInfo.in_pool(self, args)
    if G.GAME.used_jokers['c_csau_steel_tusk_2']
    or G.GAME.used_jokers['c_csau_steel_tusk_3']
    or G.GAME.used_jokers['c_csau_steel_tusk_4'] then
        return false
    end
    
    return true
end

function consumInfo.calculate(self, card, context)
    if context.individual and context.cardarea == G.play and not card.debuff then
        if context.other_card:get_id() == 14 or context.other_card:get_id() == 2 then
            if not context.blueprint and not context.retrigger_joker then
                card.ability.extra.evolve_scores = card.ability.extra.evolve_scores + 1
            end

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

    if context.after and not context.blueprint and not context.retrigger_joker and not card.ability.extra.evolved then
        if to_big(card.ability.extra.evolve_scores) >= to_big(card.ability.extra.evolve_num) then
            card.ability.extra.evolved = true
            G.E_MANAGER:add_event(Event({
                func = (function()
                    G.FUNCS.evolve_stand(card)
                    return true
                end)
            }))
        else
            return {
                message = localize{type='variable',key='a_remaining',vars={card.ability.extra.evolve_num - card.ability.extra.evolve_scores}},
                colour = G.C.STAND
            }
        end
    end
end


return consumInfo