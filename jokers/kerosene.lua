local jokerInfo = {
    name = 'Kerosene',
    config = {
        extra = {
            chips = 0,
            chip_mod = 25
        }
    },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "guestartist12", set = "Other"}
    return { vars = {card.ability.extra.chips, card.ability.extra.chip_mod} }
end

function jokerInfo.calculate(self, card, context)
    if context.end_of_round and not card.debuff and not context.individual and not context.repetition and not context.blueprint then
        if G.GAME.FLAME_ON then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.CHIPS})
            G.GAME.FLAME_ON = false
        end
    end
    if context.joker_main and context.cardarea == G.jokers and card.ability.extra.chips > 0 then
        return {
            message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
            chip_mod = card.ability.extra.chips,
            colour = G.C.CHIPS
        }
    end
end

return jokerInfo