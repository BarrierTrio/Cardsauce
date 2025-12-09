local consumInfo = {
    name = 'Whirlpool',
    set = "Planet",
    config = { hand_type = 'jojobal_Fibonacci' },
    artist = 'BarrierTrio/Gote',
    programmer = 'Kekulism'
}

consumInfo.loc_vars = function(self, info_queue, card)
    local hand = self.config.hand_type
    return { vars = {G.GAME.hands[hand].level,localize(hand, 'poker_hands'), G.GAME.hands[hand].l_mult, G.GAME.hands[hand].l_chips, colours = {(G.GAME.hands[hand].level==1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[hand].level)])}} }
end

consumInfo.in_pool = function(self, args)
    if next(SMODS.find_card("c_jojobal_steel_tusk_4")) or next(SMODS.find_card('j_fnwk_plancks_jokestar')) then
        return (G.GAME and G.GAME.hands and G.GAME.hands.jojobal_Fibonacci.played > 0)
    end
end

consumInfo.set_card_type_badge = function(self, card, badges)
    badges[1] = create_badge(localize('k_galaxy'), get_type_colour(self or card.config, card), nil, 1.2)
end

return consumInfo