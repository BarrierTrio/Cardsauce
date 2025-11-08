local jokerInfo = {
    name = 'Barbeque Shoes',
    config = {
        extra = {
            hearts_inc = 5,
            dollars_mod = 2,
        }
    },
    rarity = 1,
    cost = 7,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,
    streamer = "joel",
    artist = 'creachurearts'
}

local function get_payout(card)
    if not G.playing_cards then return 0 end
    local hearts = 0
    for k, v in pairs(G.playing_cards) do
        if v:is_suit(G.GAME and G.GAME.wigsaw_suit or "Hearts") then hearts = hearts+1 end
    end
    return math.floor(hearts / card.ability.extra.hearts_inc) * card.ability.extra.dollars_mod
end

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.dollars_mod, card.ability.extra.hearts_inc, get_payout(card), localize(G.GAME and G.GAME.wigsaw_suit or "Hearts", 'suits_plural'), colours = {G.C.SUITS[G.GAME and G.GAME.wigsaw_suit or "Hearts"]} } }
end

function jokerInfo.calc_dollar_bonus(self, card)
    if not card.debuff then
        return get_payout(card)
    end
end

return jokerInfo