local jokerInfo = {
    name = "Frens",
    atlas = 'jokers',
	pos = {x = 3, y = 11},
    config = {
        extra = {
            chips_mod = 5,
        },
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'SagaciousCejai'
}

local function get_faces()
    local faces = 0
    if G.playing_cards then
        for k, v in pairs(G.playing_cards) do
            if v:is_face() and not v.debuff then faces = faces+1 end
        end
    end
    return faces
end

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.chips_mod, card.ability.extra.chips_mod * get_faces()} }
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main then
        local faces = get_faces()
        if faces > 0 then
            return {
                chips = card.ability.extra.chips_mod * faces,
            }
        end
    end
end

return jokerInfo