local consumInfo = {
    name = 'Protojoker',
    atlas = 'spectrals',
    pos = {x = 1, y = 0},
    soul_pos = {x = 2, y = 0},
    set = "Spectral",
    cost = 4,
    hidden = true,
    soul_rate = 0.003,
    soul_set = "Joker",
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
    artist = 'Lyman (JankJonklers)',
}

function consumInfo.use(self, card, area, copier)
    check_for_unlock({ type = "activate_protojoker" })
    for i = 1, #G.jokers.cards do
        if ArrowAPI.string.contains(G.jokers.cards[i].ability.name, "Joker") and not G.jokers.cards[i].getting_sliced then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    ArrowAPI.game.transform_card(G.jokers.cards[i], 'j_csau_chad')
                    return true
                end
            }))
        end
    end
end

function consumInfo.can_use(self, card)
    for i = 1, #G.jokers.cards do
        if ArrowAPI.string.contains(G.jokers.cards[i].ability.name, "Joker") then
            return true
        end
    end
end

return consumInfo