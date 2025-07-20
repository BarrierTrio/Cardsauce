local consumInfo = {
    name = 'Top Slots',
    key = 'topslots',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        extra = {
            max_initial_money = 20,

            winnings = 0,
            conv_money = 1,
            conv_score = 20,
            prob_double = 6,
            double = 2,
            prob_triple = 8,
            triple = 3,

            runtime = 2,
            uses = 0,
        },
        alt_title = true,
        activated = false,
        destroy = false,
    },
    origin = 'rlm'
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.chvsau } }

    local num, dom1 = SMODS.get_probability_vars(card, 1, card.ability.extra.prob_double, 'csau_topslots_double')
    local _, dom2 = SMODS.get_probability_vars(card, 1, card.ability.extra.prob_triple, 'csau_topslots_triple')
    
    return { 
        vars = {
            card.ability.extra.conv_money,
            card.ability.extra.conv_score,
            card.ability.extra.max_initial_money,
            num, dom1, dom2,
            card.ability.extra.runtime-card.ability.extra.uses
        },
        key = self.key..'_alt_title'
    }
end

function consumInfo.calculate(self, card, context)
    if card.debuff or context.blueprint then return end

    if card.ability.activated and context.end_of_round and not context.repetition and not context.individual and G.GAME.chips > G.GAME.blind.chips then
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
        card.ability.extra.uses = card.ability.extra.uses + 1
        if doubled or tripled then
            return {
                message = localize((doubled and tripled and 'k_ts_wild') or (doubled and not tripled and 'k_ts_doubled') or (tripled and not doubled and 'k_ts_tripled')),
                card = card
            }
        end
    end

    if context.starting_shop and not context.blueprint then
        if to_big(card.ability.extra.uses) >= to_big(card.ability.extra.runtime) then
            G.FUNCS.destroy_tape(card)
            card.ability.destroyed = true
        end
    end

    if card.ability.activated and context.game_over then
        check_for_unlock({ type = "the_scot" })
    end
end

function consumInfo.calc_dollar_bonus(self, card)
    if card.ability.extra.winnings then
        return card.ability.extra.winnings
    end
end

function consumInfo.can_use(self, card)
    if to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit) or card.area == G.consumeables then return true end
end

return consumInfo