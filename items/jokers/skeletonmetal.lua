local jokerInfo = {
    name = 'Skeleton Metal',
    config = {
        extra = 2,
    },
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_steel
    return { vars = { card.ability.extra } }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.before and to_big(G.GAME.current_round.hands_left) == to_big(0) then
        local cards = {}
        for i=1, card.ability.extra do
            local _card = create_playing_card({
                front = pseudorandom_element(G.P_CARDS, pseudoseed('hereinmycoffin')),
                center = G.P_CENTERS.m_steel}, G.hand, nil, nil, {G.C.SECONDARY_SET.Enhanced})
            G.GAME.blind:debuff_card(_card)
            cards[#cards+1] = _card
        end

        playing_card_joker_effects({cards})

        G.hand:sort()

        local juice_card = context.blueprint_card or card
        juice_card:juice_up()
    end
end

return jokerInfo
