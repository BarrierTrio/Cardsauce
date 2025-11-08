local jokerInfo = {
    name = "Jokerdrive",
    config = {
        extra = {
            mult_mod = 15,
        },
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    has_shiny = true,
    streamer = "otherjoel",
    part = 'phantom',
    artist = 'BarrierTrio/Gote'
}


local function get_mult(card)
    if not G.FUNCS.csau_get_leftmost_stand() then
        return 15
    else
        return 0
    end
end

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.mult_mod } }
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main and context.cardarea == G.jokers and get_mult(card) > 0 then
        return {
            mult = get_mult(card)
        }
    end
end

return jokerInfo