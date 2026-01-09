local consumInfo = {
    name = 'Top Slots',
    atlas = 'vhs',
	pos = {x = 6, y = 1},
    set = "VHS",
    runtime = 2,
    cost = 6,
    alerted = true,
    config = {
        extra = {
            max_winnings = 20,
            winnings = 0,
            money_mod = 1,
            score_per = 0.2,
            prob_double = 6,
            prob_triple = 8,
        },
        alt_title = true,
    },
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'rlm',
        },
        custom_color = 'rlm'
    },
    artist = 'chvsau'
}

function consumInfo.loc_vars(self, info_queue, card)
    local num, dom1 = SMODS.get_probability_vars(card, 1, card.ability.extra.prob_double, 'csau_topslots_double')
    local _, dom2 = SMODS.get_probability_vars(card, 1, card.ability.extra.prob_triple, 'csau_topslots_triple')

    return {
        vars = {
            card.ability.extra.money_mod,
            card.ability.extra.score_per * 100,
            card.ability.extra.max_winnings,
            num, dom1, dom2,
        },
        key = self.key..'_alt'
    }
end

function consumInfo.calculate(self, card, context)
    if card.debuff or context.blueprint then return end

    if context.end_of_round and context.main_eval and not context.game_over then
        local percent = ((G.GAME.chips - G.GAME.blind.chips) / G.GAME.blind.chips)
        card.ability.extra.winnings = math.min(card.ability.extra.max_winnings, math.floor(percent / card.ability.extra.score_per) * card.ability.extra.money_mod)
    end

    if card.ability.activated and context.game_over then
        check_for_unlock({ type = "the_scot" })
    end
end

function consumInfo.calc_dollar_bonus(self, card)
    if card.ability.activated then
        local winnings = card.ability.extra.winnings
        ArrowAPI.vhs.run_tape(card)

        if winnings == 0 then
            return winnings
        end
        local doubled, tripled = false, false
        if SMODS.pseudorandom_probability(card, 'csau_topslots_double', 1, card.ability.extra.prob_double) then
            money = money * card.ability.extra.double
            doubled = true
        end
        if SMODS.pseudorandom_probability(card, 'csau_topslots_triple', 1, card.ability.extra.prob_triple) then
            money = money * card.ability.extra.triple
            tripled = true
        end


        if doubled or tripled then
            local loc_key = (doubled and tripled and 'k_ts_wild') or (doubled and 'k_ts_doubled') or 'k_ts_tripled'
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = localize(loc_key),
                colour = G.C.MONEY,
            })
        end

        return card.ability.extra.winnings
    end
end

return consumInfo