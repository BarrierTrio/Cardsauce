local csc = Card.set_cost
function Card.set_cost(self)
    csc(self)
    if (self.ability.set == 'VHS' or (self.ability.set == 'Booster' and self.ability.name:find('Analog'))) then
        if #SMODS.find_card('j_csau_weretrulyfrauds') > 0 then
            self.cost = 0
        end
    end
end

local jokerInfo = {
    name = "WE'RE TRULY FRAUDS!",
    config = {},
    rarity = 2,
    cost = 8,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "othervinny",
    csau_dependencies = {
        'enableVHSs',
    },
    origin = {
        'rlm',
        'rlm_wotw',
        color = 'rlm'
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
