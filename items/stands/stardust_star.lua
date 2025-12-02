local consumInfo = {
    name = 'Star Platinum',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'c640ffDC' , 'f96bffDC' },
        extra = {
            suit = 'Diamons',
            hand_mod = 1,
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'stardust',
        },
        custom_color = 'stardust'
    },
    blueprint_compat = true,
    artist = 'BarrierTrio/Gote',
}

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.hand_mod, localize(card.ability.extra.suit, 'suits_plural'), colours = {G.C.SUITS[card.ability.extra.suit]} } }
end

function consumInfo.calculate(self, card, context)
    if context.before and not card.debuff and to_big(G.GAME.current_round.hands_played) == to_big(0)
    and ArrowAPI.game.all_same_suit(context.full_hand, card.ability.extra.suit) then
        local flare_card = context.blueprint_card or card
        ease_hands_played(card.ability.extra.hand_mod)
        return {
            func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.50)
            end,
            extra = {
                card = flare_card,
                message = localize{type = 'variable', key = 'a_hands', vars = {card.ability.extra.hand_mod}},
                colour = G.C.BLUE
            }
        }
    end
end


return consumInfo