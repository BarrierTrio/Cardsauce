local jokerInfo = {
    name = 'Wigsaw',
    config = {},
    rarity = 4,
    cost = 20,
    unlocked = false,
    unlock_condition = {type = '', extra = '', hidden = true},
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    hasSoul = true,
    streamer = "joel",
    artist = 'BarrierTrio/Gote'
}

local function get_highest_suit(suits)
    local highest_suit = nil
    local highest_count = -1
    local count_highest = 0

    for suit, count in pairs(suits) do
        if count > highest_count then
            highest_suit = suit
            highest_count = count
            count_highest = 1
        elseif count == highest_count then
            count_highest = count_highest + 1
        end
    end

    if count_highest > 1 then
        return nil
    else
        return highest_suit
    end
end

function jokerInfo.add_to_deck(self, card)
    G.E_MANAGER:add_event(Event({
        func = function()
            reset_idol_card()
            local valid_choicevoice_cards = {}
            for _, v in ipairs(G.playing_cards) do
                if not SMODS.has_no_suit(v) then
                    if (G.GAME and G.GAME.wigsaw_suit and v:is_suit(G.GAME.wigsaw_suit)) or (G.GAME and not G.GAME.wigsaw_suit) then
                        valid_choicevoice_cards[#valid_choicevoice_cards+1] = v
                    end
                end
            end
            if valid_choicevoice_cards[1] then
                local randCard = pseudorandom_element(valid_choicevoice_cards, pseudoseed('marrriooOOO'..G.GAME.round_resets.ante))
                G.GAME.current_round.choicevoice.suit = randCard.base.suit
                G.GAME.current_round.choicevoice.rank = randCard.base.value
                G.GAME.current_round.choicevoice.id = randCard.base.id
            end
            return true
        end
    }))
end

function jokerInfo.remove_from_deck(self, card)
    G.E_MANAGER:add_event(Event({
        func = function()
            G.GAME.wigsaw_suit = nil
            return true
        end
    }))
end

function jokerInfo.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    G.FUNCS.generate_legendary_desc(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
end

function jokerInfo.update(self, card)
    if card.area and card.area == G.jokers and G.playing_cards then
        local suit_tallies = {}
        for i, v in ipairs(G.playing_cards) do
            if v.base.suit then suit_tallies[v.base.suit] = (suit_tallies[v.base.suit] or 0) + 1 end
        end
        local highest = get_highest_suit(suit_tallies)
        G.GAME.wigsaw_suit = highest
    end
end

return jokerInfo
--[[

JOKERS AFFECTED BY WIGSAW MANUALLY (FUCK):

Vanilla:

--JOKERS:
- Greedy Joker ✔️
- Lusty Joker ✔️
- Wrathful Joker ✔️
- Gluttonous Joker ✔️
- Blackboard ✔️
- Ancient Joker ✔️
- Castle ✔️
- Rough Gem ✔️
- Bloodstone ✔️
- Arrowhead ✔️
- Onyx Agate ✔️
- Flowerpot ✔️
- The Idol ✔️
- Seeing Double ✔️

--CONSUMABLES:
- The Star ✔️
- The Moon ✔️
- The Sun ✔️
- The World ✔️
- Sigil ✔️

Cardsauce:

--JOKERS:
- The Purple Joker ✔️
- Cousin's Club ✔️
- Why Are You Red? ✔️
- Joey's Castle ✔️
- Choicest Voice ✔️
- Barbeque Shoes ✔️
- Dancing Joker ✔️

--STANDS:
- Star Platinum ✔️
- DIO's World ✔️
- Gold Experience ✔️

]]--