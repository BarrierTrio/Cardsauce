local jokerInfo = {
    name = "Bald Joker",
    atlas = 'jokers',
	pos = {x = 8, y = 9},
    config = {
        extra = {
            dollars = 3,
            min_discard = 5
        },
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    has_shiny = true,
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.dollars } }
end

function jokerInfo.calculate(self, card, context)
    if context.pre_discard and to_big(#context.full_hand) >= to_big(5) then
        local non_face_count = 0
        for i, v in ipairs(context.full_hand) do
            if not v:is_face() and not v.debuff then
                non_face_count = non_face_count + 1
            end
        end

        if non_face_count >= 5 then
            local mod = math.floor(non_face_count / 5)
            return {
                dollars = card.ability.extra.dollars*mod,
            }
        end
    end
end

return jokerInfo
