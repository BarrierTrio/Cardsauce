local consumInfo = {
    name = 'Fateful Findings',
    key = 'fatefulfindings',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        activated = false,
        destroyed = false,
        extra = {
            runtime = 3,
            uses = 0,
        },
    },
    artist = 'Burdrehnar'
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    return { vars = { card.ability.extra.runtime-card.ability.extra.uses } }
end

local function find_first_card(cards)
    for i, v in ipairs(cards) do
        if v.ability.set == 'Tarot' or v.ability.set == 'Planet' or v.ability.set == 'Spectral' then
            return v
        end
    end
    return
end

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.open_booster then
        if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
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
                        card.ability.extra.uses = card.ability.extra.uses+1
                        if to_big(card.ability.extra.uses) >= to_big(card.ability.extra.runtime) then
                            G.FUNCS.destroy_tape(card)
                            card.ability.destroyed = true
                        end
                    end
                    return true
                end
            }))
        end
    end
end

function consumInfo.can_use(self, card)
    if to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit) or card.area == G.consumeables then return true end
end

return consumInfo