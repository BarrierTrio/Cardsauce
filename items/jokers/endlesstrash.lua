local jokerInfo = {
    name = "ENDLESS TRASH",
    atlas = 'jokers',
	pos = {x = 4, y = 14},
    config = {
        extra = {
            discard_mod = 1,
            current_mod = 0,
        },
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    dependencies = {
        config = {
            ['VinnyContent'] = true,
            ['VHSs'] = true,
        }
    },
    origin = {
        category = 'rlm',
        sub_origins = {'rlm_hitb'},
        custom_color = 'rlm'
    },
    artist = 'yunkie101'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.discard_mod } }
end

function jokerInfo.add_to_deck(self, card, from_debuff)
    card.ability.extra.current_mod = ArrowAPI.vhs.get_vhs_count() * card.ability.extra.discard_mod
    if card.ability.extra.current_mod > 0 then
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.current_mod
        ease_discard(card.ability.extra.current_mod)
        card_eval_status_text(card, 'extra', nil, nil, nil, {
            message = "+"..card.ability.extra.current_mod.." "..localize('k_hud_discards'),
            colour = G.C.RED,
        })
    end
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    if card.ability.extra.current_mod > 0 then
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.current_mod
        ease_discard(-card.ability.extra.current_mod)
    end
    card.ability.extra.current_mod = 0
end

function jokerInfo.calculate(self, card, context)
    if card.debuff or context.blueprint then return end

    if context.card_added and context.card.ability.set == 'VHS' then
        card.ability.extra.current_mod = card.ability.extra.current_mod + card.ability.extra.discard_mod
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discard_mod
        ease_discard(card.ability.extra.discard_mod)
        card_eval_status_text(card, 'extra', nil, nil, nil, {
            message = "+"..card.ability.extra.discard_mod.." "..localize('k_hud_discards'),
            colour = G.C.RED,
        })

    end

    if context.removed_card and context.removed_card.ability.set == 'VHS' then
        card.ability.extra.current_mod = math.card.ability.extra.current_mod - card.ability.extra.discard_mod
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discard_mod
        ease_discard(-card.ability.extra.discard_mod)
        card_eval_status_text(card, 'extra', nil, nil, nil, {
            message = "-"..card.ability.extra.discard_mod.." "..localize('k_hud_discards'),
            colour = G.C.RED,
        })
    end
end

return jokerInfo

