local csc = Card.set_cost
function Card.set_cost(self)
    csc(self)
    self.sell_cost = self.sell_cost + (self.ability.csau_extra_value or 0)
end

local jokerInfo = {
    name = 'Bye-Bye, Norway',
    config = {
        extra = {
            dollars_mod = 4
        },
        csau_extra_value = 0,
    },
    rarity = 3,
    cost = 10,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    streamer = "joel",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.guff } }
    return { vars = { card.ability.extra.dollars_mod } }
end

function jokerInfo.calculate(self, card, context)
    if context.selling_self then
        local destroyed_cards = {}
        for i, v in ipairs(G.hand.cards) do
            if v:is_face() then
                destroyed_cards[#destroyed_cards+1] = v
            end
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                for i=#destroyed_cards, 1, -1 do
                    local card = destroyed_cards[i]
                    if card.ability.name == 'Glass Card' then
                        card:shatter()
                    else
                        card:start_dissolve(nil, i == #destroyed_cards)
                    end
                end
                return true
            end }))
    end
end

function jokerInfo.update(self, card)
    if card.area == G.jokers and G.hand and #G.hand.cards > 0 then
        local face_cards = {}
        for i, v in ipairs(G.hand.cards) do
            if v:is_face() then
                face_cards[#face_cards+1] = v
            end
        end
        card.ability.csau_extra_value = card.ability.extra.dollars_mod * #face_cards
        card:set_cost()
    end
end

return jokerInfo
	