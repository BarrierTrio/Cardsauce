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
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
    return { vars = { card.ability.extra.chips } }
end

function jokerInfo.add_to_deck(self, card)

end

function jokerInfo.calculate(self, card, context)
    if G.GAME.current_round.discards_used <= 0 and #context.full_hand == 1 and context.discard and not context.blueprint and not card.debuff then
        local destroy = context.full_hand[1]
        local rank = SMODS.Ranks[destroy.base.value]
        local chips = rank.nominal
        local bonus_chip = context.other_card.ability.perma_bonus or 0
        card.ability.extra.chips = card.ability.extra.chips + chips + bonus_chip
        return {
            message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
            colour = G.C.CHIPS,
            delay = 0.45,
            remove = true,
            card = card
        }
    end
    if card.ability.extra.chips > 0 and context.joker_main and context.cardarea == G.jokers and not card.debuff then
        return {
            chips = card.ability.extra.chips,
        }
    end
end

return jokerInfo