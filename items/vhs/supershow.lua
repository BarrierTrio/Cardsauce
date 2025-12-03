local consumInfo = {
    name = 'The Super Mario Bros. Super Show',
    key = 'supershow',
    set = "VHS",
    runtime = 3,
    cost = 3,
    blueprint_compat = false,
    config = {},
    origin = 'vinny',
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'MightyKingWario'
}

function consumInfo.calculate(self, card, context)
    if card.debuff or context.blueprint then return end

    if card.ability.activated and context.remove_playing_cards then
        check_for_unlock({ type = "activate_supershow" })
        G.E_MANAGER:add_event(Event({
            func = function()
                local new_cards = {}
                for _, v in ipairs(context.removed) do
                    if not card.ability.destroyed then
                        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                        local new_card = copy_card(v, nil, nil, G.playing_card, true)
                        new_card:set_edition(poll_edition('csau_supershow', nil, true, true), true)
                        new_card:add_to_deck()
                        G.deck.config.card_limit = G.deck.config.card_limit + 1
                        table.insert(G.playing_cards, new_card)

                        new_card.states.visible = false
                        new_card:hard_set_T(G.ROOM.T.x + G.ROOM.T.w/2 - new_card.T.w/2, G.ROOM.T.y + G.ROOM.T.h/2 - new_card.T.h/2, new_card.T.w, new_card.T.h)

                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            func = function()
                                card:juice_up()
                                new_card:start_materialize({G.C.SECONDARY_SET.Enhanced})
                                return true
                            end
                        }))
                        delay(0.65)
                        draw_card(nil, G.deck, 90, 'up', nil, new_card)

                        new_cards[#new_cards+1] = new_card

                        ArrowAPi.vhs.run_tape(card)
                    end
                end

                if #new_cards > 0 then
                    playing_card_joker_effects(new_cards)
                end

                return true
            end
        }))
    end
end

return consumInfo