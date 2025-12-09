local jokerInfo = {
    name = "ENDLESS TRASH",
    atlas = 'jokers',
	pos = {x = 4, y = 14},
    config = {
        extra = 1,
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
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
    return { vars = { card.ability.extra } }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.setting_blind then
        local count = ArrowAPI.vhs.get_vhs_count()
        if count > 0 then
            ease_discard(card.ability.extra*count)
            return {
                message = "+"..count.." "..localize('k_hud_discards'),
                card = context.blueprint_card or card
            }
        end
    end
end

return jokerInfo

