local jokerInfo = {
    name = "WE'RE TRULY FRAUDS!",
    config = {},
    rarity = 2,
    cost = 8,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    dependencies = {
        config = {
            ['VinnyContent'] = true,
            ['VHSs'] = true
        }
    },
    origin = {
        category = 'rlm',
        sub_origins = {'rlm_wotw'},
        custom_color = 'rlm'
    },
    artist = 'Lyzerus'
}

-- TODO: can easily add this as an arrow API function
local function refresh_costs()
    G.E_MANAGER:add_event(Event({func = function()
        for k, v in pairs(G.I.CARD) do
            if v.set_cost then v:set_cost() end
        end
        return true
    end }))
end

function jokerInfo.add_to_deck(self, card)
    refresh_costs()
end

function jokerInfo.remove_from_deck(self, card)
    refresh_costs()
end

return jokerInfo
