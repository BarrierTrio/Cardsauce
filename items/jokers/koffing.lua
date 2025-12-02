local jokerInfo = {
    name = "That Fucking Koffing Again",
    config = {extra = {rerolled = false}},
    rarity = 1,
    cost = 5,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    origin = 'vinny',
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'BarrierTrio/Gote',
    programmer = 'Mysthaps'
}

-- TODO: implement koffing's reroll behavior using only contexts
function jokerInfo.calculate(self, card, context)
    if context.ending_shop and not context.blueprint then
        card.ability.extra.rerolled = false
    end
end

return jokerInfo