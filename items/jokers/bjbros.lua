local jokerInfo = {
    name = 'Blowzo Brothers',
    config = {
        extra = {
            prob_1 = 4,
            prob_2 = 4
        }

    },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "vinny",
    artist = "FenixSeraph"
}

function jokerInfo.loc_vars(self, info_queue, card)
    local num, dom1 = SMODS.get_probability_vars(card, 1, card.ability.extra.prob_1, 'csau_bjbros1')
    local _, dom2 = SMODS.get_probability_vars(card, 1, card.ability.extra.prob_2, 'csau_bjbros2')
    return { vars = {num, dom1, dom2 } }
end

function jokerInfo.calculate(self, card, context)
    if not (context.cardarea == G.jokers and context.before) or card.debuff then
        return
    end

    if context.scoring_name == "Two Pair"  then
        local bj1 = false
        local bj2 = false
        if SMODS.pseudorandom_probability(card, 'csau_bjbros1', 1, card.ability.extra.prob_1) then
            bj1 = true
        end

        for _, v in ipairs(context.scoring_hand) do
            if SMODS.pseudorandom_probability(card, 'csau_bjbros2', 1, card.ability.extra.prob_2) then
                if not bj2 then bj2 = true end

                v:set_ability(pseudorandom_element(G.P_CENTER_POOLS.Enhanced, pseudoseed('csau_brothers_enhancement')), nil, true)
                local juice_card = context.blueprint_card or card
                G.E_MANAGER:add_event(Event({
                    func = function()
                        juice_card:juice_up()
                        return true
                    end
                }))

                card_eval_status_text(v, 'extra', nil, nil, nil, {
                    message = localize('k_enhanced'),
                })
            end
        end

        if bj1 then
            if bj2 then
                check_for_unlock({ type = "gamer_blowzo" })
            end

            return {
                card = card,
                level_up = true,
                message = localize('k_level_up_ex')
            }
        end
    end
end

return jokerInfo