local jokerInfo = {
    name = 'Rapture',
    config = {
        extra = {
            mult = 0,
            mult_mod = 1
        }
    },
    rarity = 1,
    cost = 6,
    unlocked = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    unlock_condition = {type = 'win_no_hand', extra = 'High Card'},
    streamer = "vinny",
    artist = 'Burdrehnar'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult }}
end

function jokerInfo.calculate(self, card, context)
    local bad_context = context.repetition or context.individual or context.blueprint
    if context.cardarea == G.jokers and context.before and not card.debuff and not bad_context then
        if context.scoring_name == "High Card" then
            if to_big(card.ability.extra.mult) > to_big(0) then
                card.ability.extra.mult = to_big(0)
                return {
                    message = localize('k_reset'),
                    colour = G.C.RED
                }
            end
        else
            card.ability.extra.mult = to_big(card.ability.extra.mult) + to_big(card.ability.extra.mult_mod)
            if to_big(card.ability.extra.mult) >= to_big(30) and next(find_joker('2 Kings 2:23-24')) then
                check_for_unlock({ type = "supreme_ascend" })
            end
            return {
                card = card,
                message = localize{type='variable',key='a_mult',vars={to_big(card.ability.extra.mult)}}
            }
        end
    end
    if context.joker_main and context.cardarea == G.jokers and not card.debuff then
        if to_big(card.ability.extra.mult) > to_big(0) then
            return {
                mult = card.ability.extra.mult,
            }
        end
    end
end

return jokerInfo
