local jokerInfo = {
    name = 'Photodad',
    config = {},
    rarity = 2,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    hasSoul = true,
    streamer = "joel",
    csau_dependencies = {
        'enableStands',
        'enableJoelContent'
    },
    artist = 'BarrierTrio/Gote'
}

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and context.before and not card.debuff and to_big(G.GAME.current_round.hands_left) == to_big(0) then
        G.E_MANAGER:add_event(Event({func = function()
            if to_big(G.consumeables.config.card_limit) > to_big(#G.consumeables.cards) then
                play_sound('timpani')
                local _card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_csau_tarot_arrow', 'photodad')
                _card:add_to_deck()
                G.consumeables:emplace(_card)
                card:juice_up(0.3, 0.5)
            end
            return true
        end }))
    end
end

return jokerInfo
