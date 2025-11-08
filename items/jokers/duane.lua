local jokerInfo = {
    name = 'Dancing Joker',
    config = {
        extra = {
            repetitions = 1,
        }
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "joel",
    animated = {
        tiles = {
            x = 39,
        },
        speed = 0.075
    },
    artist = 'elebant'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { localize(G.GAME and G.GAME.wigsaw_suit or G.GAME.current_round.duane_suit, 'suits_singular'), colours = {G.C.SUITS[G.GAME and G.GAME.wigsaw_suit or G.GAME.current_round.duane_suit]}} }
end

local function get_suit_y(suit)
    if suit and suit == 'Hearts' then
        return 1
    elseif suit and suit == 'Clubs' then
        return 2
    elseif suit and suit == 'Diamonds' then
        return 3
    elseif suit and suit == 'Spades' then
        return 4
    else
        return 5
    end
end

function jokerInfo.calculate(self, card, context)
    if context.csau_duane_change then
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_duane', vars = {string.upper(localize(context.suit, 'suits_plural'))}}})
    end
    if context.cardarea == G.play and context.repetition and not context.repetition_only and not card.debuff then
        if context.other_card:is_suit(G.GAME and G.GAME.wigsaw_suit or G.GAME.current_round.duane_suit) then
            return {
                message = 'Again!',
                repetitions = card.ability.extra.repetitions,
                card = card
            }
        end
    end
end

function jokerInfo.set_sprites(self, card, _front)
    if card.config.center.discovered or card.bypass_discovery_center then
        local obj = G.P_CENTERS.j_csau_duane
        local duane_suit = G.GAME and G.GAME.wigsaw_suit or G.GAME.current_round.duane_suit or nil
        obj.pos.y = get_suit_y(duane_suit)
    end
end

local igo = Game.init_game_object
function Game:init_game_object()
    local ret = igo(self)
    ret.current_round.duane_suit = 'Diamonds'
    return ret
end

local delay_duane = false
function jokerInfo.update(self, card)
    local obj = G.P_CENTERS.j_csau_duane
    local duane_suit = G.GAME and G.GAME.wigsaw_suit or G.GAME.current_round.duane_suit or nil
    if get_suit_y(duane_suit) ~= obj.pos.y and not delay_duane then
        delay_duane = true
        G.E_MANAGER:add_event(Event({
            func = function()
                obj.pos.y = get_suit_y(duane_suit)
                delay_duane = false
                return true
            end,
        }))
    end
end

return jokerInfo
