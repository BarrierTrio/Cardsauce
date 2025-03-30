local jokerInfo = {
    name = 'Blowzo Brothers',
    config = {
        prob_1 = 2,
        prob_2 = 4
    },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.fenix } }
    return { vars = {G.GAME.probabilities.normal, card.ability.prob_1, card.ability.prob_2 } }
end

function jokerInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_bjbros" })
end

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and context.before and not card.debuff then
        if context.scoring_name == "Two Pair" then
            if pseudorandom('bjbros2') < G.GAME.probabilities.normal / card.ability.prob_2 then
                if not context.blueprint_card then
                    card:juice_up()
                    local enhancements = {
                        [1] = G.P_CENTERS.m_bonus,
                        [2] = G.P_CENTERS.m_mult,
                        [3] = G.P_CENTERS.m_wild,
                        [4] = G.P_CENTERS.m_glass,
                        [5] = G.P_CENTERS.m_steel,
                        [6] = G.P_CENTERS.m_stone,
                        [7] = G.P_CENTERS.m_gold,
                        [8] = G.P_CENTERS.m_lucky,
                    }
                    local card_1 = pseudorandom('bjbros', 1, #context.scoring_hand)
                    local card_2
                    repeat
                        card_2 = pseudorandom('second_pick', 1, #context.scoring_hand)
                    until card_2 ~= card_1
                    for i, v in ipairs(context.scoring_hand) do
                        if (i == card_1 or i == card_2) and v.ability.effect == "Base" then
                            v:set_ability(enhancements[pseudorandom('hookedonthebros', 1, 8)], nil, true)
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    v:juice_up()
                                    return true
                                end
                            }))
                        end
                    end
                end
            end
            if pseudorandom('bjbros1') < G.GAME.probabilities.normal / card.ability.prob_1 then
                return {
                    card = card,
                    level_up = true,
                    message = localize('k_level_up_ex')
                }
            end
        end
    end
end

return jokerInfo