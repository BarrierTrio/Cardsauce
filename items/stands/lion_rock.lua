local consumInfo = {
    name = 'I Am a Rock',
    set = 'Stand',
    config = {
        aura_colors = { '7ec7ffDC', 'ffbb49DC' },
        stand_mask = true,
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'lion',
        },
        custom_color = 'lion'
    },
    blueprint_compat = true,
    artist = 'BarrierTrio/Gote',
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stone
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.playing_card_added then
        local cards = {}
        for i, v in ipairs(context.cards) do
            if not v.jojobal_rock_effect then
                local new_stone = SMODS.create_card({
					set = 'Enhanced',
					enhancement = 'm_stone',
					key = 'm_stone',
					skip_materialize = true,
				})

                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                new_stone.playing_card = G.playing_card
                table.insert(G.playing_cards, new_stone)
                G.deck.config.card_limit = G.deck.config.card_limit + 1

                new_stone.states.visible = false
                new_stone:add_to_deck()
                new_stone:hard_set_T(G.ROOM.T.x + G.ROOM.T.w/2 - new_stone.T.w/2, G.ROOM.T.y + G.ROOM.T.h/2 - new_stone.T.h/2, new_stone.T.w, new_stone.T.h)
                new_stone.jojobal_rock_effect = true

                cards[#cards+1] = new_stone
            end
        end

        if #cards > 0 then
            playing_card_joker_effects(cards)

            return {
                func = function()
                    local juice_card = context.blueprint_card or card
                    for i, v in ipairs(cards) do
                        local percent = (i-0.999)/(#cards-0.998)*0.2
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v.states.visible = true
                                v:start_materialize({G.C.SECONDARY_SET.Enhanced})
                                return true
                            end
                        }))
                        card_eval_status_text(juice_card, 'extra', nil, percent, nil, {
                            message = localize('k_upgrade_ex'),
                            colour = G.C.STAND,
                            delay = 0.75
                        })
                        draw_card(nil, G.discard, i*100/#context.cards, 'up', false, v)
                    end
                end,
            }
        end
    end
end

return consumInfo