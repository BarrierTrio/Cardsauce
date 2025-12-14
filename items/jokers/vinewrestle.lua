local jokerInfo = {
    name = 'Vinewrestle',
    atlas = 'jokers',
	pos = {x = 8, y = 13},
    config = {},
    rarity = 2,
    cost = 6,
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
    artist = 'SagaciousCejai'
}

function jokerInfo.calculate(self, card, context)
    local bad_context = context.repetition or context.individual or context.blueprint
    if context.end_of_round and G.GAME.blind.boss and not card.debuff and not bad_context then
        local key, color = ArrowAPI.game.get_tag_by_type('joker', 'ITSSOMOAJOE')
        return {
            message = localize('k_plus_one')..localize({type = 'name_text', set = 'Tag', key = key}),
            colour = color,
            extra = {
                func = function()
                    add_tag(Tag(key))
                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                end
            }
        }
    end
end

return jokerInfo
