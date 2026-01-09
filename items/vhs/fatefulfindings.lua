local consumInfo = {
    name = 'Fateful Findings',
    atlas = 'vhs',
	pos = {x = 1, y = 2},
    set = "VHS",
    runtime = 5,
    cost = 6,
    config = {},
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'rlm',
        },
        custom_color = 'rlm'
    },
    blueprint_compat = false,
    artist = 'Burdrehnar'
}

local function find_first_card(cards)
    for i, v in ipairs(cards) do
        if v.ability.set == 'Tarot' or v.ability.set == 'Planet' or v.ability.set == 'Spectral' then
            return v
        end
    end
end

function consumInfo.calculate(self, card, context)
    if card.debuff or context.blueprint then return end

    if card.ability.activated and context.open_booster and
    #G.consumeables.cards < G.consumeables.config.card_limit then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                local stolen_card = find_first_card(G.pack_cards.cards)
                if stolen_card then
                    stolen_card.area:remove_card(stolen_card)
                    stolen_card:add_to_deck()
                    if stolen_card.children.price then
                        stolen_card.children.price:remove()
                    end
                    stolen_card.children.price = nil
                    if stolen_card.children.buy_button then
                        stolen_card.children.buy_button:remove()
                    end
                    stolen_card.children.buy_button = nil
                    remove_nils(stolen_card.children)
                    G.consumeables:emplace(stolen_card)

                    ArrowAPI.vhs.run_tape(card)
                end
                return true
            end
        }))
    end
end

return consumInfo