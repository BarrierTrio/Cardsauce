local consumInfo = {
    name = 'Fateful Findings',
    atlas = 'vhs',
	pos = {x = 1, y = 2},
    set = "VHS",
    runtime = 3,
    cost = 3,
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
                local _card = find_first_card(G.pack_cards.cards)
                if _card then
                    _card.area:remove_card(_card)
                    _card:add_to_deck()
                    if _card.children.price then
                        _card.children.price:remove()
                    end
                    _card.children.price = nil
                    if _card.children.buy_button then
                        _card.children.buy_button:remove()
                    end
                    _card.children.buy_button = nil
                    remove_nils(_card.children)
                    G.consumeables:emplace(_card)
                    card:juice_up()

                    ArrowAPI.vhs.run_tape(card)
                end
                return true
            end
        }))
    end
end

return consumInfo