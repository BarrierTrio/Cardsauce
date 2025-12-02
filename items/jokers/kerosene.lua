local jokerInfo = {
    name = 'Kerosene',
    atlas = 'jokers',
	pos = {x = 1, y = 4},
    config = {
        extra = {
            chips = 0,
            chip_mod = 20,
            flame = false,
        }
    },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    streamer = "vinny",
    origin = "redvox",
    artist = 'WhimsyCherry'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.chips, card.ability.extra.chip_mod} }
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main and context.cardarea == G.jokers and to_big(card.ability.extra.chips) > to_big(0) then
        return {
            message = localize{type='variable',key='a_chips',vars={to_big(card.ability.extra.chips)}},
            chip_mod = card.ability.extra.chips,
            colour = G.C.CHIPS
        }
    end
    if context.final_scoring_step then
        G.E_MANAGER:add_event(Event({
            func = function()
                if to_big(G.ARGS.score_intensity.earned_score) >= to_big(G.ARGS.score_intensity.required_score) and to_big(G.ARGS.score_intensity.required_score) > to_big(0) then
                    card.ability.extra.flame = true
                end
                return true
            end
        }))
    end
    if context.end_of_round and not card.debuff and not context.individual and not context.repetition and not context.blueprint then
        if card.ability.extra.flame then
            card.ability.extra.flame = false
            card.ability.extra.chips = to_big(card.ability.extra.chips) + to_big(card.ability.extra.chip_mod)
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS
            }
        end
    end
end

return jokerInfo