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
    rarity = 'StandRarity',
    hasSoul = true,
    blueprint_compat = false,
    origin = {
        category = 'jojo',
        sub_origins = {
            'vento',
        },
        custom_color = 'vento'
    },
    artist = 'BarrierTrio/Gote',
    programmer = 'Kekulism'
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
    info_queue[#info_queue+1] = G.P_CENTERS.m_glass
end

function consumInfo.calculate(self, card, context)
    if card.debuff or context.blueprint or context.retrigger_joker then return end

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
                    ArrowAPI.stands.flare_aura(card, 0.50)
                end,
                extra = {
                    message = localize('k_metal'),
                    card = card,
                }
            }
        end
    end

    if context.check_enhancement and context.other_card.config.center.key == 'm_steel' and context.other_card.base.value == 'Jack' then
        return {
            ['m_glass'] = true,
        }
	end

    if context.individual and context.cardarea == G.play and context.other_card.config.center.key == 'm_steel'
    and context.other_card.base.value == 'Jack' then
        ArrowAPI.stands.flare_aura(card, 0.50)
        delay(0.5)
    end
end

return consumInfo