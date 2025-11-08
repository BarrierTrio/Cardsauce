local consumInfo = {
    name = 'Soft & Wet: Go Beyond',
    set = 'Stand',
    config = {
        aura_colors = { 'ebfafeDC', 'b48df1DC' },
        stand_mask = true,
        evolved = true,
        extra = {
            perma_mod = 1,
        }
    },
    cost = 10,
    rarity = 'EvolvedRarity',
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'lion',
        },
        custom_color = 'lion'
    },
    blueprint_compat = true,
    artist = 'Stupisms',
    programmer = 'Kekulism'
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_bonus
    info_queue[#info_queue+1] = G.P_CENTERS.m_mult
end

function consumInfo.in_pool(self, args)
    return (not G.GAME.used_jokers['c_jojobal_lion_soft'])
end

function consumInfo.calculate(self, card, context)
    if context.before and not card.debuff then
        local enhanced = {}
        for _, v in ipairs(context.scoring_hand) do
            if ((v.config.center.key == 'm_bonus' or v.config.center.key == 'm_mult') or v.jjba_soft_effect) and not v.debuff then
                enhanced[#enhanced+1] = v

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

                if v.config.center.key == 'm_bonus' or v.config.center.key == 'm_mult' then
                    v:set_ability(G.P_CENTERS.c_base, nil, 'manual')
                end
            end
        end

        if #enhanced > 0 then
            local flare_card = context.blueprint_card or card
            return {
                func = function()
                    for i, v in ipairs(enhanced) do
                        local color = v.jjba_soft_effect == 'm_mult' and G.C.MULT or G.C.CHIPS
                        local percent = (i-0.999)/(#enhanced-0.998)*0.2
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:set_sprites(v.config.center)
                                return true
                            end
                        }))
                        card_eval_status_text(v, 'extra', nil, percent, nil, {
                            message = localize('k_upgrade_ex'),
                            colour = color,
                            delay = 0.25
                        })
                    end
                    ArrowAPI.stands.flare_aura(flare_card, 0.50)
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
                return true
            end
        }))
    end
end


return consumInfo