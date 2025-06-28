local consumInfo = {
    name = 'Metallica',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'F97C87DA', 'CE3749DA' },
        extra = {
            x_mult = 2,
        }
    },
    cost = 4,
    rarity = 'arrow_StandRarity',
    hasSoul = true,
    blueprint_compat = false,
    part = 'vento',
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
    info_queue[#info_queue+1] = G.P_CENTERS.m_glass
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { G.jojobal_mod_team.gote } }
end

function consumInfo.calculate(self, card, context)
    if context.blueprint or context.retrigger_joker or card.debuff then return end

    if context.before then
        local transformed = 0
        for _, v in ipairs(context.full_hand) do
            if v.base.value == 'Jack' and v.config.center.key == 'c_base' then
                transformed = transformed + 1
                v:set_ability(G.P_CENTERS.m_steel, nil, true)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        v:juice_up()
                        return true
                    end
                }))
            end
        end
        if transformed > 0 then
            return {
                func = function()
                    G.FUNCS.flare_stand_aura(card, 0.50)
                end,
                extra = {
                    message = localize('k_metal'),
                    card = card,
                }
            }
        end
    end

    if context.check_enhancement then
		if context.other_card.config.center.key == 'm_steel' and context.other_card.base.value == 'Jack' then
            return {
                ['m_glass'] = true,
            }
        end
	end

    if context.individual and context.cardarea == G.play and not card.debuff and not context.repetition then
        if context.other_card.config.center.key == 'm_steel'and context.other_card.base.value == 'Jack' then
            G.FUNCS.flare_stand_aura(card, 0.50)
        end
    end
end

return consumInfo