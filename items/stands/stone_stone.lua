local consumInfo = {
    name = 'Stone Free',
    set = 'csau_Stand',
    config = {
        aura_colors = { '4db8cfDC', '4d89cfDC' },
        stand_mask = true,
        extra = {
            chips = 60,
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    part = 'stone',
    blueprint_compat = true
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stone
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.chvsau } }
    return { vars = {card.ability.extra.chips}}
end

function consumInfo.calculate(self, card, context)
    if context.before and not card.debuff then
        local stones = {}
        for _, v in ipairs(context.scoring_hand) do
            if v.config.center.key == 'm_stone' or v.csau_stone_effect then
                stones[#stones+1] = v     
   
                if not v.csau_stone_effect then
                    v.csau_stone_effect = true
                end

                v.ability.perma_bonus = v.ability.perma_bonus or 0
                v.ability.perma_bonus = v.ability.perma_bonus + card.ability.extra.chips

                if v.config.center.key == 'm_stone' then
                    v:set_ability(G.P_CENTERS.c_base, nil, 'manual')
                end
            end         
        end

        if #stones > 0 then
            local flare_card = context.blueprint_card or card
            return {
                func = function()
                    for i, v in ipairs(stones) do
                        local percent = (i-0.999)/(#stones-0.998)*0.2
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:set_sprites(v.config.center)
                                return true
                            end
                        }))
                        card_eval_status_text(v, 'extra', nil, percent, nil, {
                            message = localize('k_upgrade_ex'),
                            delay = 0.25
                        })
                    end
                    G.FUNCS.csau_flare_stand_aura(flare_card, 0.5)
                end,
                extra = {
                    message = localize('k_stone_free'),
                    colour = G.C.STAND,
                    card = flare_card
                }
            }
        end
    end
end


return consumInfo