local consumInfo = {
    name = 'Troll 2',
    atlas = 'vhs',
	pos = {x = 4, y = 0},
    set = "VHS",
    runtime = 3,
    cost = 3,
    alerted = true,
    config = {},
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'vinny',
        },
        custom_color = 'vinny'
    },
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'yunkie101'
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_stone
end

function consumInfo.calculate(self, card, context)
    if card.debuff or context.blueprint then return end

    if card.ability.activated and context.before then
        local eligable_cards = {}
        for i, v in ipairs(G.hand.cards) do
            if v.ability.effect == "Base" then
                table.insert(eligable_cards, v)
            end
        end
        if #eligable_cards > 0 then
            local rand_card = pseudorandom_element(eligable_cards, pseudoseed('youcantpissonhospitality'))
            rand_card:set_ability(G.P_CENTERS.m_stone, nil, true)
            G.E_MANAGER:add_event(Event({
                func = function()
                    rand_card:juice_up()
                    return true
                end
            }))

            ArrowAPI.vhs.run_tape(card)

            return {
                message = localize('k_troll2'),
                card = card
            }
        end
    end
end

return consumInfo