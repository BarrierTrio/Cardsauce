local ref_create_card = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    local ret = ref_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    SMODS.calculate_context({csau_created_card = ret, area = area})
    return ret
end

local ref_level_up = level_up_hand
function level_up_hand(card, hand, instant, amount)
    amount = amount or 1
    local eff = {}
    SMODS.calculate_context({modify_level_increment = true, card = card, hand = hand, amount = amount}, eff)
    SMODS.trigger_effects(eff)
    for i, v in ipairs(eff) do
        if v.jokers then
            if v.jokers.mult_inc then
                amount = amount * v.jokers.mult_inc
            end
        end
    end

    return ref_level_up(card, hand, instant, amount)
end