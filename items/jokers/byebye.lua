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
    unlocked = false,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,
    has_shiny = true,
    unlock_condition = {type = 'win_deck', deck = 'b_abandoned'},
    streamer = "joel",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.guff } }
    return { vars = { card.ability.extra.dollars_mod } }
end

function jokerInfo.check_for_unlock(self, args)
    if (args.type == "win_deck" and get_deck_win_stake(self.unlock_condition.deck)) then
        return true
    end
end

function jokerInfo.calculate(self, card, context)
    if context.hand_drawn or context.other_drawn then
        local faces = 0
        for i, v in ipairs(G.hand.cards) do
            if v:is_face() then
                faces = faces + 1
            end
        end
        card.ability.csau_extra_value = card.ability.extra.dollars_mod * faces
        card:set_cost()
    end

    if context.selling_self then
        local destroyed_cards = {}
        for _, v in ipairs(G.hand.cards) do
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
            end 
        }))
    end
end

return jokerInfo
	