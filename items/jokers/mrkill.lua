local jokerInfo = {
    name = "Mr. Kill",
    config = {
        extra = {
            chips = 0,
        },
    },
    rarity = 2,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    streamer = "joel",
    artist = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.chips } }
end

function jokerInfo.calculate(self, card, context)
    if context.first_hand_drawn then
        local eval = function() return to_big(G.GAME.current_round.discards_used) == to_big(0) and not G.RESET_JIGGLES end
        juice_card_until(card, eval, true)
    end
    if context.discard and to_big(G.GAME.current_round.discards_used) <= to_big(0) and #context.full_hand == 1 and context.discard and not context.blueprint and not card.debuff then
        local destroy = context.full_hand[1]
        local rank = SMODS.Ranks[destroy.base.value]
        local chips = SMODS.has_no_rank(destroy) and 0 or rank.nominal
        local bonus_chip = destroy.ability.bonus + (destroy.ability.perma_bonus or 0)
        card.ability.extra.chips = card.ability.extra.chips + chips + bonus_chip
        return {
            message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
            colour = G.C.CHIPS,
            delay = 0.45,
            remove = true,
            card = card
        }
    end
    if to_big(card.ability.extra.chips) > to_big(0) and context.joker_main and context.cardarea == G.jokers and not card.debuff then
        return {
            chips = card.ability.extra.chips,
        }
    end
end

return jokerInfo