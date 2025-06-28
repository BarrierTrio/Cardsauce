local ref_create_card = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    local ret = ref_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    SMODS.calculate_context({csau_created_card = ret, area = area})
    return ret
end