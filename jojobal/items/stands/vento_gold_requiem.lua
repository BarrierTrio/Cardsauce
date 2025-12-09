local consumInfo = {
    name = 'Gold Experience Requiem',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { '99d3ffDC' , 'd3f5fbDC' },
        evolved = true,
        extra = {
            chance = 5,
        }
    },
    cost = 10,
    rarity = 'EvolvedRarity',
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'vento',
        },
        custom_color = 'vento'
    },
    blueprint_compat = true,
    artist = {'Redastrin', 'MightyKingWario'},
    programmer = 'Kekulism'
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_gold
    return { vars = { SMODS.get_probability_vars(card, 1, card.ability.extra.chance, 'jojobal_ge_requiem') }}
end

function consumInfo.in_pool(self, args)
    return (not G.GAME.used_jokers['c_jojobal_vento_gold'])
end

function consumInfo.calculate(self, card, context)
    if context.before and not card.debuff then
        local tick_cards = {}
        for _, v in ipairs(context.scoring_hand) do
            if SMODS.has_enhancement(v, 'm_gold') and SMODS.pseudorandom_probability(card, 'jojobal_ge_requiem', 1, card.ability.extra.chance) then
                tick_cards[#tick_cards+1] = v
            end
        end

        if #tick_cards > 0 then
            local flare_card = context.blueprint_card or card
            return {
                func = function()
                    ArrowAPI.stands.flare_aura(flare_card, 0.50)
                    for i = 1, #tick_cards do
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            func = function()
                                tick_cards[i]:juice_up()
                                play_sound('card1')
                            return true
                        end }))
                    end
                end,
                extra = {
                    card = flare_card,
                    level_up = #tick_cards,
                    message = localize{type = 'variable', key = 'a_multilevel', vars = {#tick_cards}},
                }
            }
        end
    end
end


return consumInfo