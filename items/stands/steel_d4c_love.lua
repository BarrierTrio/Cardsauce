local consumInfo = {
    name = 'D4C -Love Train-',
    set = 'Stand',
    config = {
        aura_colors = { 'f3b7f5DC', '8ae5ffDC' },
        stand_mask = true,
        evolved = true,
    },
    cost = 10,
    rarity = 'EvolvedRarity',
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'steel',
        },
        custom_color = 'steel'
    },
    blueprint_compat = false,
    artist = 'gote',
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_lucky
end

function consumInfo.in_pool(self, args)
    return (not G.GAME.used_jokers['c_jojobal_steel_d4c'])
end

local ref_eval_card = eval_card
function eval_card(card, context)
    local ret, post = ref_eval_card(card, context)

    if card and context.cardarea == G.play and context.main_scoring and not card.debuff and card.config.center.key == 'm_lucky'
    and ret.playing_card and not ret.playing_card.mult and not ret.playing_card.p_dollars then
        if next(SMODS.find_card('c_jojobal_steel_d4c_love')) then
            local triggers = {'mult', 'p_dollars'}
            local key = pseudorandom_element(triggers, pseudoseed('jojobal_lovetrain'))
            ret.playing_card[key] = (ret.playing_card[key] or 0) + card.ability[key]

            if key == 'p_dollars' and ret.playing_card[key] ~= 0 then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + ret.playing_card[key]
                G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
            end
        end
    end

    return ret, post
end

return consumInfo