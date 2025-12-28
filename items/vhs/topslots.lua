local consumInfo = {
    name = 'Top Slots',
    atlas = 'vhs',
	pos = {x = 6, y = 1},
    set = "VHS",
    runtime = 2,
    cost = 3,
    alerted = true,
    config = {
        extra = {
            max_initial_money = 20,
            winnings = 0,
            conv_money = 1,
            conv_score = 20,
            prob_double = 6,
            double = 2,
            prob_triple = 8,
            triple = 3,
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
            card.ability.extra.conv_money,
            card.ability.extra.conv_score,
            card.ability.extra.max_initial_money,
            num, dom1, dom2,
        },
        key = self.key..'_alt_title'
    }
end

function consumInfo.calculate(self, card, context)
    if card.debuff or context.blueprint then return end

    if card.ability.activated and context.end_of_round and context.main_eval and G.GAME.chips > G.GAME.blind.chips then
        local percent = ((G.GAME.chips - G.GAME.blind.chips) / G.GAME.blind.chips) * 100
        local money = math.floor(percent / card.ability.extra.conv_score) + card.ability.extra.conv_money
        if to_big(money) > to_big(card.ability.extra.max_initial_money) then
            money = card.ability.extra.max_initial_money
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

        card.ability.extra.winnings = money

        ArrowAPI.vhs.run_tape(card)

        if doubled or tripled then
            return {
                message = localize((doubled and tripled and 'k_ts_wild') or (doubled and not tripled and 'k_ts_doubled') or (tripled and not doubled and 'k_ts_tripled')),
                card = card
            }
        end
    end

    if card.ability.activated and context.game_over then
        check_for_unlock({ type = "the_scot" })
    end
end

function consumInfo.calc_dollar_bonus(self, card)
    return card.ability.extra.winnings
end

return consumInfo