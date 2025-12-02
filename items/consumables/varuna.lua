local consumInfo = {
    name = 'Varuna',
    set = "Planet",
    config = { hand_type = 'csau_FlushBlackjack' },
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'Kekulism',
}

consumInfo.loc_vars = function(self, info_queue, card)
    local hand = self.config.hand_type
    return { vars = {G.GAME.hands[hand].level,localize(hand, 'poker_hands'), G.GAME.hands[hand].l_mult, G.GAME.hands[hand].l_chips, colours = {(G.GAME.hands[hand].level==1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[hand].level)])}} }
end

consumInfo.in_pool = function(self, args)
    if next(SMODS.find_card("j_csau_blackjack")) then
        return (G.GAME and G.GAME.hands and to_big(G.GAME.hands.csau_FlushBlackjack.played) > to_big(0))
    end
end

consumInfo.set_card_type_badge = function(self, card, badges)
    badges[1] = create_badge(localize('k_dwarf_planet'), get_type_colour(self or card.config, card), nil, 1.2)
end

return consumInfo