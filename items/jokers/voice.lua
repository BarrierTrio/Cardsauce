local jokerInfo = {
    name = "Choicest Voice",
    config = {
        voice_hand = "High Card",
        extra = {
            repetitions = 1
        }
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "other",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.akai } }
    return { vars = { localize(card.ability.voice_hand, 'poker_hands'), localize(G.GAME.current_round.choicevoice.rank, 'ranks'), localize(G.GAME.current_round.choicevoice.suit, 'suits_plural'), colours = {G.C.SUITS[G.GAME.current_round.choicevoice.suit]} }}
end

function jokerInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_voice" })
end

function jokerInfo.set_ability(self, card, initial, delay_sprites)
    local _poker_hands = {}
    for k, v in pairs(G.GAME.hands) do
        if v.visible then _poker_hands[#_poker_hands+1] = k end
    end
    card.ability.voice_hand = pseudorandom_element(_poker_hands, pseudoseed((card.area and card.area.config.type == 'title') and 'false_voice' or 'voice'))
end

function jokerInfo.calculate(self, card, context)
    if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
        local _poker_hands = {}
        for k, v in pairs(G.GAME.hands) do
            if v.visible then _poker_hands[#_poker_hands+1] = k end
        end
        local old_hand = card.ability.voice_hand
        card.ability.voice_hand = nil

        while not card.ability.voice_hand do
            card.ability.voice_hand = pseudorandom_element(_poker_hands, pseudoseed((card.area and card.area.config.type == 'title') and 'false_voice' or 'voice'))
            if card.ability.voice_hand == old_hand then card.ability.voice_hand = nil end
        end
    end
    if context.cardarea == G.play and context.repetition and not context.repetition_only and not card.debuff then
        if next(context.poker_hands[card.ability.voice_hand]) then
            for k, v in ipairs(context.full_hand) do
                if v:is_suit(G.GAME.current_round.choicevoice.suit) and v:get_id() == G.GAME.current_round.choicevoice.id then
                    return {
                        message = 'Again!',
                        repetitions = card.ability.extra.repetitions,
                        card = context.other_card
                    }
                end
            end
        end
    end
end

local igo = Game.init_game_object
function Game:init_game_object()
    local ret = igo(self)
    ret.current_round.choicevoice = { suit = 'Clubs', rank = 'Ace', id = 14 }
    return ret
end

return jokerInfo