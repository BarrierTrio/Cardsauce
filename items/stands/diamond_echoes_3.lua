local consumInfo = {
    name = 'Echoes ACT3',
    set = 'csau_Stand',
    config = {
        evolved = true,
        stand_mask = true,
        aura_colors = { 'f9ec4bDC', '6edb75DC' },
        extra = {
            mult = 5,
            xmult = 1.5,
        }
    },
    cost = 10,
    rarity = 'csau_EvolvedRarity',
    hasSoul = true,
    part = 'diamond',
    blueprint_compat = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stone
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.chvsau } }
    return {vars = {card.ability.extra.mult, card.ability.extra.xmult}}
end

function consumInfo.in_pool(self, args)
    if G.GAME.used_jokers['c_csau_diamond_echoes_1']
    or G.GAME.used_jokers['c_csau_diamond_echoes_2'] then
        return false
    end
    
    return true
end

function consumInfo.calculate(self, card, context)
    if context.individual and context.cardarea == G.play and not card.debuff then
        if context.other_card.ability.effect == 'Stone Card' then
            local flare_card = context.blueprint_card or card
            return {
                func = function()
                    G.FUNCS.csau_flare_stand_aura(flare_card, 0.50)
                end,
                extra = {
                    x_mult = card.ability.extra.xmult,
                    card = flare_card
                }
            }
        end
        if next(context.poker_hands['Flush']) and not context.other_card.debuff then
            local flare_card = context.blueprint_card or card
			return {
                func = function()
                    G.FUNCS.csau_flare_stand_aura(flare_card, 0.50)
                end,
                extra = {
                    mult = card.ability.extra.mult,
				    card = flare_card
                }
			}
		end
    end
end

local ref_is = Card.is_suit
function Card:is_suit(suit, bypass_debuff, flush_calc)
    if next(SMODS.find_card("c_csau_diamond_echoes_3")) and SMODS.has_enhancement(self, 'm_stone') then return true end
    return ref_is(self, suit, bypass_debuff, flush_calc)
end


return consumInfo