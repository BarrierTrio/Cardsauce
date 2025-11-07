local consumInfo = {
    name = 'Echoes ACT3',
    set = 'Stand',
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
    rarity = 'EvolvedRarity',
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'diamond',
        },
        custom_color = 'diamond'
    },
    blueprint_compat = true,
    artist = 'chvsau'
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stone
    return {vars = {card.ability.extra.mult, card.ability.extra.xmult}}
end

function consumInfo.in_pool(self, args)
    if G.GAME.used_jokers['c_jojobal_diamond_echoes_1']
    or G.GAME.used_jokers['c_jojobal_diamond_echoes_2'] then
        return false
    end
    
    return true
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.individual and context.cardarea == G.play then
        local x_mult = SMODS.has_enhancement(context.other_card, 'm_stone') and card.ability.extra.xmult or nil
        local mult = next(context.poker_hands['Flush']) and card.ability.extra.mult or nil

        if not x_mult and not mult then
            return
        end

        local flare_card = context.blueprint_card or card

        return {
            func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.50)
            end,
            extra = {
                mult = mult,
                x_mult = x_mult,
                card = flare_card
            }
        }
    end
end

local ref_is = Card.is_suit
function Card:is_suit(suit, bypass_debuff, flush_calc)
    local echoes = SMODS.find_card("c_jojobal_diamond_echoes_3")
    return (next(echoes) and SMODS.has_enhancement(self, 'm_stone')) or ref_is(self, suit, bypass_debuff, flush_calc)
end


return consumInfo