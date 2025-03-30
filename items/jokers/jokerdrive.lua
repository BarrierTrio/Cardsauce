local jokerInfo = {
    name = "Jokerdrive",
    config = {
        extra = {
            mult_mod = 5,
        },
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "otherjoel",
}


local function get_mult(card)
    if not G.FUNCS.get_leftmost_stand() then
        return G.GAME.round_resets.ante * card.ability.extra.mult_mod
    else
        return 0
    end
end

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
    return { vars = { card.ability.extra.mult_mod, get_mult(card) } }
end

function jokerInfo.add_to_deck(self, card)

end

function jokerInfo.calculate(self, card, context)
    if context.joker_main and context.cardarea == G.jokers then
        return {
            mult = get_mult(card)
        }
    end
end

return jokerInfo