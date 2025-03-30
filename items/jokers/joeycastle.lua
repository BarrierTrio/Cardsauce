local jokerInfo = {
    name = "Joey's Castle",
    config = {
        money = 1,
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "joel",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gappie } }
    return { vars = { card.ability.money, localize(G.GAME and G.GAME.wigsaw_suit or G.GAME.current_round.joeycastle.suit, 'suits_singular'), colours = {G.C.SUITS[G.GAME and G.GAME.wigsaw_suit or G.GAME.current_round.joeycastle.suit]} }}
end

function jokerInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_joeycastle" })
end

function jokerInfo.calculate(self, card, context)
    if context.discard and not context.other_card.debuff and context.other_card:is_suit(G.GAME and G.GAME.wigsaw_suit or G.GAME.current_round.joeycastle.suit) and not context.blueprint then
        return {
            dollars = to_big(card.ability.money),
            colour = G.C.MONEY,
            card = card
        }
    end
end

local igo = Game.init_game_object
function Game:init_game_object()
    local ret = igo(self)
    ret.current_round.joeycastle = { suit = 'Clubs' }
    return ret
end

return jokerInfo