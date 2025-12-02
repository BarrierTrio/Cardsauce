local jokerInfo = {
    name = "Choicest Voice",
    config = {
        extra = {
            repetitions = 1
        }
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    origin = 'cardsauce',
    artist = 'Akai (Balatrostuck)'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { localize(G.GAME.current_round.choicevoice.rank, 'ranks'), localize(G.GAME.current_round.choicevoice.suit, 'suits_plural'), colours = {G.C.SUITS[G.GAME.current_round.choicevoice.suit]} }}
end

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.play and context.repetition and not context.repetition_only and not card.debuff then

        for k, v in ipairs(context.full_hand) do
            if v:is_suit(G.GAME.current_round.choicevoice.suit) and v:get_id() == G.GAME.current_round.choicevoice.id then
                check_for_unlock({ type = "activate_voice" })
                return {
                    message = 'Again!',
                    repetitions = card.ability.extra.repetitions,
                    card = context.other_card
                }
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