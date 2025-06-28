local consumInfo = {
    name = 'Gold Experience Requiem',
    set = 'csau_Stand',
    config = {
        stand_mask = true,
        aura_colors = { '99d3ffDC' , 'd3f5fbDC' },
        evolved = true,
        extra = {
            chance = 5,
        }
    },
    cost = 10,
    rarity = 'csau_EvolvedRarity',
    hasSoul = true,
    part = 'vento',
    blueprint_compat = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_gold
    info_queue[#info_queue+1] = {key = "artistcredit_2", set = "Other", vars = { G.jojobal_mod_team.reda, G.jojobal_mod_team.wario } }
    return { vars = { SMODS.get_probability_vars(card, 1, card.ability.extra.chance) }}
end

function consumInfo.in_pool(self, args)
    if next(SMODS.find_card('j_showman')) then
        return true
    end
    return (not G.GAME.used_jokers['c_jojobal_vento_gold'])
end

function consumInfo.calculate(self, card, context)
    if context.before and not card.debuff then
        local tick_cards = {}
        for _, v in ipairs(context.scoring_hand) do
            if SMODS.has_enhancement(v, 'm_gold') and SMODS.pseudorandom_probability(card, pseudoseed('csau_ge_requiem'), 1, card.ability.extra.chance) then
                tick_cards[#tick_cards+1] = v
            end
        end

        local levels = #tick_cards
        if levels > 0 then
            for i = 1, levels do
                G.E_MANAGER:add_event(Event({ 
                    trigger = 'before',
                    delay = 0.3,
                    func = function() 
                        tick_cards[i]:juice_up()
                        play_sound('card1')
                    return true 
                end })) 
            end

            local flare_card = context.blueprint_card or card
            return {
                func = function()
                    G.FUNCS.flare_stand_aura(flare_card, 0.50)
                end,
                extra = {
                    card = flare_card,
                    level_up = levels,
                    message = localize{type = 'variable', key = 'a_multilevel', vars = {levels}},
                }
            }
        end
    end
end


return consumInfo