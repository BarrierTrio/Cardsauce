local jokerInfo = {
    name = '2 Kings 2:23-24',
    config = {
        extra = {
            x_mult = 5,
            cards = {}
        },
    },
    rarity = 3,
    cost = 6,
    unlocked = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true
}

function jokerInfo.check_for_unlock(self, args)
    if args.type == "unlock_kings" then
        return true
    end
end

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "guestartist10", set = "Other"}
    return { vars = { card.ability.extra.x_mult } }
end

local draw_from_deck_to_destroy = function(e)
    for i=1, e do
        draw_card(G.deck,G.csau_destroy, i*100/e,'up', true)
    end
end

local draw_from_destroy_to_deck = function(e)
    for i=1, e do
        draw_card(G.csau_destroy,G.deck, i*100/e,'up', true)
    end
end

local function findCard(suit, id)
    for k, v in pairs(G.P_CARDS) do
        local cardId = tonumber(v.value) or
                (v.value == "Jack" and 11) or
                (v.value == "Queen" and 12) or
                (v.value == "King" and 13) or
                (v.value == "Ace" and 14)

        if v.suit == suit and cardId == id then
            return k
        end
    end
    return nil
end

function jokerInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_kings" })
    if G.GAME.buttons then G.GAME.buttons:remove(); G.GAME.buttons = nil end
    local yOffset = -4
    if G.shop and not G.shop.REMOVED then
        G.shop.alignment.offset.y = G.ROOM.T.y+11
    else
        yOffset = -5
    end

    G.csau_destroy = CardArea(
            G.TILE_W - G.hand.T.w - 2.65,
            G.TILE_H - G.hand.T.h + yOffset,
            6*G.CARD_W,
            0.95*G.CARD_H,
            {card_limit = 42,
             card_w = 0.6*G.CARD_W, type = 'title', highlight_limit = 0})

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    draw_from_deck_to_destroy(42)

                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.5,
                        func = function()
                            for i = 1, #G.csau_destroy.cards do
                                local _card = G.csau_destroy.cards[i]
                                local edition = nil
                                if _card.edition then
                                    edition = _card.edition.type
                                end
                                local id = _card:get_id()
                                local suit = _card.base.suit
                                local key = findCard(suit, id)
                                table.insert(
                                    card.ability.extra.cards,
                                    {
                                        key,
                                        _card.ability.effect,
                                        _card.seal or nil,
                                        edition
                                    }
                                )
                                if _card.ability.name == 'Glass Card' then
                                    _card:shatter()
                                else
                                    _card:start_dissolve(nil, i == #G.csau_destroy.cards)
                                end
                            end
                            return true end }))

                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 1,
                        func = function()
                            if G.shop and not G.shop.REMOVED then G.shop.alignment.offset.y = -5.3 end
                            return true end }))
                    return true
                end
            }))
            return true
        end
    }))
end

local function removeCardSuffix(str)
    if string.sub(str, -5) == " Card" then
        return string.sub(str, 1, -6)
    else
        return str
    end
end

function jokerInfo.remove_from_deck(self, card)
    if G.playing_cards ~= nil and #card.ability.extra.cards > 0 then
        if G.GAME.buttons then G.GAME.buttons:remove(); G.GAME.buttons = nil end
        local yOffset = -4
        if G.shop and not G.shop.REMOVED then
            G.shop.alignment.offset.y = G.ROOM.T.y+11
        else
            yOffset = -5
        end

        G.csau_destroy = CardArea(
                G.TILE_W - G.hand.T.w - 2.65,
                G.TILE_H - G.hand.T.h + yOffset,
                6*G.CARD_W,
                0.95*G.CARD_H,
                {card_limit = 42,
                 card_w = 0.6*G.CARD_W, type = 'title', highlight_limit = 0})

        for i, v in ipairs(card.ability.extra.cards) do
            local key = v[1]
            local effect = v[2]
            local center
            if effect == "Base" then
                center = 'c_base'
            else
                center = 'm_'..string.lower(removeCardSuffix(effect))
            end
            local seal = v[3]
            local edition = v[4]

            local _card = create_playing_card({front = G.P_CARDS[key], center = G.P_CENTERS[center]}, G.csau_destroy, nil, nil, {G.C.SECONDARY_SET.Enhanced})
            if seal then _card:set_seal(seal, true) end
            if edition == "foil" then
                _card:set_edition({foil = true}, true, true)
            elseif edition == "holo" then
                _card:set_edition({holo = true}, true, true)
            elseif edition == "polychrome" then
                _card:set_edition({polychrome = true}, true, true)
            end
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.25,
            func = function()
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        draw_from_destroy_to_deck(#G.csau_destroy.cards)
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 1,
                            func = function()
                                if G.shop and not G.shop.REMOVED then G.shop.alignment.offset.y = -5.3 end
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return true
            end
        }))
    end
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main and context.cardarea == G.jokers then
        return {
            message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}},
            Xmult_mod = card.ability.extra.x_mult,
        }
    end
end

return jokerInfo


