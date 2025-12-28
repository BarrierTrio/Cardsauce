local jokerInfo = {
    name = 'Skeleton Metal',
    atlas = 'jokers',
	pos = {x = 9, y = 13},
    config = {
        extra = 2,
    },
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'joel',
        },
        custom_color = 'joel'
    },
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
        local juice_card = context.blueprint_card or card
        for i=1, card.ability.extra do
            local new_card = SMODS.add_card({
                set = 'Enhanced',
                area = G.hand,
                enhancement = 'm_steel',
                key = 'm_steel',
                skip_materialize = true
            })

            new_card.states.visible = nil
            G.deck.config.card_limit = G.deck.config.card_limit + 1

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                func = function()
                    juice_card:juice_up()
                    new_card:start_materialize()
			        return true
                end
            }))

            cards[#cards+1] = new_card
        end

        playing_card_joker_effects({cards})
    end
end

return jokerInfo
