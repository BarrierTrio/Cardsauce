local jokerInfo = {
    name = 'Gravity',
    atlas = 'jokers',
	pos = {x = 3, y = 15},
    config = {
        extra = {
            mult = 0,
            mult_mod = 4,
        }
    },
    rarity = 1,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    origin = 'jojo',
    dependencies = {
        config = {
            ['Stands'] = true,
        }
    },
    artist = 'BarrierTrio/Gote',
    programmer = 'Kekulism'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult } }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.joker_main and card.ability.extra.mult > 0 then
        return {
            mult = card.ability.extra.mult,
        }
    end

    if context.blueprint then return end

    if context.setting_blind and ArrowAPI.stands.get_num_stands() > 0 then
        SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = "mult",
            scalar_value = "mult_mod",
        })
    end

    if context.removed_card and context.removed_card.ability.set == 'Stand' then
        card.ability.extra.mult = 0
        return {
            card = card,
            message = localize('k_reset')
        }
    end
end

return jokerInfo