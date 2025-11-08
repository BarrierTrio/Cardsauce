local jokerInfo = {
    name = "Battle of the Genres",
    config = {
        extra = {
            h_mod = 1,
        },
        added_h_size = 0,
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "othervinny",
    csau_dependencies = {
        'enableVHSs',
    },
    origin = {
        'rlm',
        'rlm_botw',
        color = 'rlm'
    },
    artist = 'yunkie101'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.h_mod, G.FUNCS.get_vhs_count()*card.ability.extra.h_mod } }
end

function jokerInfo.add_to_deck(self, card)
    local count = G.FUNCS.get_vhs_count()
    if count > 0 then
        G.hand:change_size(card.ability.extra.h_mod * count)
        card.ability.added_h_size = card.ability.added_h_size + card.ability.extra.h_mod * count
    end
end

function jokerInfo.remove_from_deck(self, card)
    if card.ability.added_h_size > 0 then
        G.hand:change_size(-card.ability.added_h_size)
        card.ability.added_h_size = 0
    end
end

function jokerInfo.calculate(self, card, context)
    if context.blueprint or card.debuff then return end

    if context.vhs_death and card.ability.added_h_size > card.ability.extra.h_mod then
        G.hand:change_size(-card.ability.extra.h_mod)
        card.ability.added_h_size = card.ability.added_h_size - card.ability.extra.h_mod
        card:juice_up()
    end

    if context.card_added and context.card.ability.set == "VHS" then
        G.hand:change_size(card.ability.extra.h_mod)
        card.ability.added_h_size = card.ability.added_h_size + card.ability.extra.h_mod
        card:juice_up()
    end

    if context.selling_card and context.card.ability.set == "VHS" and card.ability.added_h_size > card.ability.extra.h_mod then
        G.hand:change_size(-card.ability.extra.h_mod)
        card.ability.added_h_size = card.ability.added_h_size - card.ability.extra.h_mod
        card:juice_up()
    end
end

return jokerInfo