local jokerInfo = {
    name = "Couple's Joker",
    config = {
        extra = 1,
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "joel",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.wario } }
    return { vars = {card.ability.extra, (G.GAME and G.GAME.hands and G.GAME.hands.Pair.played) or 0} }
end

function jokerInfo.calculate(self, card, context)
    if G.GAME.hands.Pair.played > 0 and context.joker_main and context.cardarea == G.jokers then
        return {
            mult = G.GAME.hands.Pair.played,
        }
    end
end

return jokerInfo