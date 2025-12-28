local jokerInfo = {
    name = "AGGA",
    atlas = 'jokers',
	pos = {x = 9, y = 11},
    config = {
        extra = {
            x_mult = 1,
            x_mult_mod = 0.2,
            prob = 10,
        }
    },
    rarity = 2,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'joel',
        },
        custom_color = 'joel'
    },
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'SagaciousCejai'
}

function jokerInfo.loc_vars(self, info_queue, card)
    local num, dom = SMODS.get_probability_vars(card, 1, card.ability.extra.prob, 'csau_agga')
    return { vars = {num, dom, card.ability.extra.x_mult_mod, card.ability.extra.x_mult } }
end

function jokerInfo.calculate(self, card, context)
    if context.after then
        for _, v in ipairs(G.playing_cards) do
            v['agga_retrigger_count'..card.ID] = nil
        end
    end

    if card.debuff then return end

    if context.joker_main and not card.debuff and to_big(card.ability.extra.x_mult) > to_big(1) then
        return {
            x_mult = card.ability.extra.x_mult,
        }
    end

    if context.blueprint then return end

    if context.individual and context.cardarea == G.play then
        context.other_card['agga_retrigger_count'..card.ID] = (context.other_card['agga_retrigger_count'..card.ID] and context.other_card['agga_retrigger_count'..card.ID] + 1) or 0

        if context.other_card['agga_retrigger_count'..card.ID] > 0 then
            if card.ability.extra.x_mult > 1 and SMODS.pseudorandom_probability(card, 'csau_agga', 1, card.ability.extra.prob) then
                if card.ability.extra.x_mult >= 3 then
                    check_for_unlock({ type = "high_agga" })
                end

                card.ability.extra.x_mult = to_big(1)
                return {
                    message = localize('k_reset')
                }
            else
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "x_mult",
                    scalar_value = "x_mult_mod",
                })
            end
        end
    end
end

return jokerInfo