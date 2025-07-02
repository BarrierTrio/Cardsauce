local consumInfo = {
    name = 'D4C -Love Train-',
    set = 'csau_Stand',
    config = {
        aura_colors = { 'f3b7f5DC', '8ae5ffDC' },
        stand_mask = true,
        evolved = true,
    },
    cost = 10,
    rarity = 'csau_EvolvedRarity',
    hasSoul = true,
    part = 'steel',
    blueprint_compat = false
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_lucky
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } }
end

function consumInfo.in_pool(self, args)
    return (not G.GAME.used_jokers['c_csau_steel_d4c'])
end

local ref_cie = SMODS.calculate_individual_effect
SMODS.calculate_individual_effect = function(effect, scored_card, key, amount, from_edition)
    if next(SMODS.find_card('c_csau_steel_d4c_love')) and scored_card and scored_card.ability.effect and scored_card.ability.effect == 'Lucky Card' and not from_edition then
        if key == 'mult' and effect.mult == G.P_CENTERS.m_lucky.config.mult or key == 'p_dollars' and effect.p_dollars == G.P_CENTERS.m_lucky.config.p_dollars then
            local d4cl = SMODS.find_card('c_csau_steel_d4c_love')
            for i, v in ipairs(d4cl) do
                G.FUNCS.csau_flare_stand_aura(v, 0.38)
            end
        end
    end
    return ref_cie(effect, scored_card, key, amount, from_edition)
end


return consumInfo