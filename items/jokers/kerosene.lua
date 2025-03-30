local jokerInfo = {
    name = 'Kerosene',
    config = {
        extra = {
            chips = 0,
            chip_mod = 20
        }
    },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.cherry } }
    return { vars = {card.ability.extra.chips, card.ability.extra.chip_mod} }
end

function jokerInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_kerosene" })
    ach_jokercheck(self, ach_checklists.band)
end

function jokerInfo.calculate(self, card, context)
    if context.end_of_round and not card.debuff and not context.individual and not context.repetition and not context.blueprint then
        if G.GAME.FLAME_ON and G.GAME.FLAME_ON > 0 then
            card.ability.extra.chips = to_big(card.ability.extra.chips) + to_big(card.ability.extra.chip_mod)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.CHIPS})
            G.GAME.FLAME_ON = G.GAME.FLAME_ON - 1
            if G.GAME.FLAME_ON == 0 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    func = function()
                        G.GAME.FLAME_ON = nil
                        return true
                    end
                }))
            end
        end
    end
    if context.joker_main and context.cardarea == G.jokers and to_big(card.ability.extra.chips) > to_big(0) then
        return {
            message = localize{type='variable',key='a_chips',vars={to_big(card.ability.extra.chips)}},
            chip_mod = card.ability.extra.chips,
            colour = G.C.CHIPS
        }
    end
end

return jokerInfo