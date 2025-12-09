local jokerInfo = {
    name = "Gourmand of Faramore",
    atlas = 'jokers',
	pos = {x = 7, y = 10},
    config = {},
    rarity = 2,
    cost = 5,
    unlocked = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    origin = 'vinny',
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'FenixSeraph'
}

function jokerInfo.check_for_unlock(self, args)
    if args.type == "discover_amount" then
        local discovered = 0
        for k, v in pairs(G.P_CENTERS) do
            if v.set == 'Joker' and ArrowAPI.table.contains(G.P_CENTER_POOLS.Food, v) then
                if v.discovered == true then
                    discovered = discovered + 1
                    if discovered >= 5 then
                        return true
                    end
                end
            end
        end
    end
end

function jokerInfo.calculate(self, card, context)
    if context.buying_card and context.card.config.center.key == 'j_cavendish' then
        check_for_unlock({ type = "frich_cavendish" })
    end
end

return jokerInfo