local consumInfo = {
    name = 'Soft & Wet',
    set = 'csau_Stand',
    config = {
        aura_colors = { 'cc90f6DC', '734caeDC' },
        stand_mask = true,
        evolve_key = 'c_csau_lion_soft_beyond',
        extra = {
            perma_mod = 0.5,
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    hasSoul = true,
    part = 'lion',
    blueprint_compat = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_bonus
    info_queue[#info_queue+1] = G.P_CENTERS.m_mult
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.stup } }
end

function consumInfo.in_pool(self, args)
    return (not G.GAME.used_jokers['c_csau_lion_soft_beyond'])
end

function consumInfo.calculate(self, card, context)
    if context.before and not card.debuff then
        local enhanced = 0
        for _, v in ipairs(context.scoring_hand) do
            if ((v.config.center.key == 'm_bonus' or v.config.center.key == 'm_mult') or v.jjba_soft_effect) and not v.debuff then
                enhanced = enhanced + 1

                if not v.jjba_soft_effect then
                    v.jjba_soft_effect = v.config.center.key
                end

                if v.jjba_soft_effect == 'm_bonus' then
                    v.ability.perma_bonus = v.ability.perma_bonus or 0
                    v.ability.perma_bonus = v.ability.perma_bonus + (G.P_CENTERS[v.jjba_soft_effect].config.bonus*card.ability.extra.perma_mod)
                elseif v.jjba_soft_effect == 'm_mult' then
                    v.ability.perma_mult = v.ability.perma_mult or 0
                    v.ability.perma_mult = v.ability.perma_mult + (G.P_CENTERS[v.jjba_soft_effect].config.mult*card.ability.extra.perma_mod)
                end
                
                local color = v.jjba_soft_effect == 'm_mult' and G.C.MULT or G.C.CHIPS
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if v.config.center.key == 'm_bonus' or v.config.center.key == 'm_mult' then
                            v:set_ability(G.P_CENTERS.c_base)
                        end

                        v:juice_up()
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        attention_text({
                            text = localize('k_upgrade_ex'),
                            scale = 0.7, 
                            hold = 0.55,
                            backdrop_colour = color,
                            align = 'tm',
                            major = v,
                            offset = {x = 0, y = -0.05*G.CARD_H}
                        })
                        return true
                    end
                }))
                delay(0.3)
            end
        end

        if enhanced > 0 then
            local flare_card = context.blueprint_card or card
            return {
                func = function()
                    G.FUNCS.csau_flare_stand_aura(flare_card, 0.50)
                end,
                extra = {
                    message = localize('k_soft_and_wet'),
                    colour = G.C.STAND,
                    card = flare_card
                }
            }
        end
    end

    if context.after and not context.retrigger_joker and not context.blueprint then
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, v in ipairs(context.scoring_hand) do
                    v.jjba_soft_effect = nil
                end

                if not SMODS.PokerHands[context.scoring_name].visible then
                    check_for_unlock({ type = "evolve_soft" })
                    G.FUNCS.evolve_stand(card)
                end
                return true
            end
        }))
    end
end


return consumInfo