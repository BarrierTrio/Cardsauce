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
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.fenix } }
end

function jokerInfo.check_for_unlock(self, args)
    if args.type == "discover_amount" then
        local foodDiscovered = 0
        for k, v in pairs(G.P_CENTERS) do
            if starts_with(k, 'j_') and G.foodjokers[k] then
                if v.discovered == true then
                    foodDiscovered = foodDiscovered + 1
                end
            end
        end
        if foodDiscovered >= 5 then
            return true
        end
    end
end

return jokerInfo