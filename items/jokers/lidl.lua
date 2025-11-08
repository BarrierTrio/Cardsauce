local jokerInfo = {
    name = 'Lidl',
    config = {
        extra = {
            discount = 50,
        },
        active = false,
    },
    rarity = 1,
    cost = 6,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "joel",
    artist = {'BardVergil', 'Kekulism'}
}

local function activate(bool, card)
    if bool then
        G.E_MANAGER:add_event(Event({func = function()
            G.GAME.voucher_discount = card.ability.extra.discount
            for k, v in pairs(G.I.CARD) do
                if v.set_cost then v:set_cost() end
            end
            return true
        end }))
    else
        G.E_MANAGER:add_event(Event({func = function()
            G.GAME.voucher_discount = 0
            for k, v in pairs(G.I.CARD) do
                if v.set_cost then v:set_cost() end
            end
            return true
        end }))
    end
end

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.discount } }
end

function jokerInfo.add_to_deck(self, card)
    card.ability.active = true
    activate(true, card)
end

function jokerInfo.remove_from_deck(self, card)
    card.ability.active = false
    activate(false, card)
end

function jokerInfo.update(self, card, dt)
    if card.debuff and card.ability.active then
        card.ability.active = false
        activate(false, card)
    elseif not card.debuff and not card.ability.active and card.area == G.jokers then
        card.ability.active = true
        activate(true, card)
    end
end

local igo = Game.init_game_object
function Game:init_game_object()
    local ret = igo(self)
    ret.voucher_discount = 0
    return ret
end

return jokerInfo