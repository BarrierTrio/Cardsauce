local jokerInfo = {
    name = "Gourmand of Faramore",
    config = {},
    rarity = 2,
    cost = 5,
    unlocked = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "vinny",
    artist = 'FenixSeraph'
}

function jokerInfo.check_for_unlock(self, args)
    if args.type == "discover_amount" then
        local foodDiscovered = 0
        for k, v in pairs(G.P_CENTERS) do
            if starts_with(k, 'j_') and table.contains(G.P_CENTER_POOLS.Food, v) then
                if v.discovered == true then
                    foodDiscovered = foodDiscovered + 1
                    if foodDiscovered >= 5 then
                        return true
                    end
                end
            end
        end
        for k, v in pairs(SMODS.Centers) do
            if starts_with(k, 'j_') and table.contains(G.P_CENTER_POOLS.Food, v) then
                if v.discovered == true then
                    foodDiscovered = foodDiscovered + 1
                    if foodDiscovered >= 5 then
                        return true
                    end
                end
            end
        end
        if foodDiscovered >= 5 then
            return true
        end
    end
end

function jokerInfo.calculate(self, card, context)
    if context.buying_card then
        if context.card.config.center.key == 'j_cavendish' then
            check_for_unlock({ type = "frich_cavendish" })
        end
    end
end

return jokerInfo