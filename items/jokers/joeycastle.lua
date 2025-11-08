local jokerInfo = {
    name = "Joey's Castle",
    config = {
        money = 1,
        ach_disc = 0
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "joel",
    artist = 'Gappie',
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.money, localize(G.GAME and G.GAME.wigsaw_suit or G.GAME.current_round.joeycastle.suit, 'suits_singular'), colours = {G.C.SUITS[G.GAME and G.GAME.wigsaw_suit or G.GAME.current_round.joeycastle.suit]} }}
end

function jokerInfo.calculate(self, card, context)
    if context.pre_discard then
        card.ability.ach_disc = 0
    end
    if context.discard and not context.other_card.debuff and context.other_card:is_suit(G.GAME and G.GAME.wigsaw_suit or G.GAME.current_round.joeycastle.suit) then
        card.ability.ach_disc = card.ability.ach_disc + 1
        if to_big(card.ability.ach_disc) >= to_big(5) then
            check_for_unlock({ type = "high_joeyscastle" })
        end
        return {
            dollars = card.ability.money,
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
