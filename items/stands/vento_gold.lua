local consumInfo = {
    name = 'Gold Experience',
    set = 'csau_Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'fff679DC' , 'f9d652DC' },
        evolve_key = 'c_csau_vento_gold_requiem',
        extra = {
            prob = 4,
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    hasSoul = true,
    part = 'vento',
    blueprint_compat = true
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_gold
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.wario } }
    local num, dom = SMODS.get_probability_vars(card, 1, card.ability.extra.prob)
    return {
        vars = {
            num, dom,
            localize(G.GAME and G.GAME.wigsaw_suit or "Hearts", 'suits_plural'),
            colours = {
                G.C.SUITS[G.GAME and G.GAME.wigsaw_suit or "Hearts"]
            }
        } 
    }
end

function consumInfo.in_pool(self, args)
    return (not G.GAME.used_jokers['c_csau_vento_gold_requiem'])
end

function consumInfo.calculate(self, card, context)
    if context.before and not card.debuff then
        local gold = {}
        sendDebugMessage('gold experience iteration')
        for i, v in ipairs(context.scoring_hand) do
            if v.config.center.key ~= 'm_gold' and v:is_suit(G.GAME and G.GAME.wigsaw_suit or "Hearts")
            and SMODS.pseudorandom_probability(card, pseudoseed('csau_goldexperience'), 1, card.ability.extra.prob) then
                gold[#gold+1] = v
                v:set_ability(G.P_CENTERS.m_gold, nil, 'manual')
                sendDebugMessage('setting '..i..' to gold')
            end
        end

        if #gold > 0 then
            local flare_card = context.blueprint_card or card
            return {
                func = function()
                    G.FUNCS.csau_flare_stand_aura(flare_card, 0.50)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            for _, v in ipairs(gold) do
                                v:set_sprites(v.config.center)
                                v:juice_up()
                            end
                            return true
                        end
                    }))
                    
                end,
                extra = {
                    message = localize('k_gold_exp'),
                    colour = G.C.MONEY,
                    card = flare_card,
                }
            }
        end
    end
end


return consumInfo