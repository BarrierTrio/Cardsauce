local jokerInfo = {
    name = "Jokerdrive",
    config = {
        extra = {
            mult = 15,
        },
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    origin = 'jojo',
    artist = 'BarrierTrio/Gote',
    programmer = 'Kekulism'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main and context.cardarea == G.jokers and not ArrowAPI.stands.get_leftmost_stand() then
        return {
            mult = card.ability.extra.mult
        }
    end
end

return jokerInfo