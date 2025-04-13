local consumInfo = {
    name = 'Gold Experience Requiem',
    set = 'csau_Stand',
    config = {
        aura_colors = { '99d3ffDC' , 'd3f5fbDC' },
        evolved = true,
        extra = {
            chance = 0,
            divide = 5,
        }
    },
    cost = 8,
    rarity = 'csau_EvolvedRarity',
    alerted = true,
    hasSoul = true,
    in_progress = true,
    part = 'vento',
}

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.chance, card.ability.extra.divide, G.GAME.probabilities.normal}}
end

function consumInfo.in_pool(self, args)
    if next(SMODS.find_card('j_showman')) then
        return true
    end
    
    return G.GAME.used_jokers['c_csau_vento_gold'] ~= nil
end

function consumInfo.add_to_deck(self, card)
    set_consumeable_usage(card)
end

function consumInfo.calculate(self, card, context)
    local bad_context = context.repetition or context.individual or context.blueprint
    if context.before and not card.debuff and not bad_context then
        local gold = {}
        for k, v in ipairs(context.scoring_hand) do
            if v:is_suit(G.GAME and G.GAME.wigsaw_suit or "Hearts") then
                gold[#gold+1] = v
                v:set_ability(G.P_CENTERS.m_gold, nil, true)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        v:juice_up()
                        return true
                    end
                }))
            end
        end
        if pseudorandom('thisisrequiem') < G.FUNCS.csau_add_chance(card.ability.extra.chance+#gold, true) / card.ability.extra.divide then
            return {
                card = card,
                level_up = true,
                message = localize('k_level_up_ex')
            }
        end
    end
end

function consumInfo.can_use(self, card)
    return false
end

return consumInfo