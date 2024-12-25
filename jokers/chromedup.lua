local jokerInfo = {
    name = 'Chromed Up',
    config = {
        extra = {
            x_mult = 1.77
        }
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "guestartist9", set = "Other"}
    return { vars = {card.ability.extra.x_mult} }
end

function jokerInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_chrome" })
end

function jokerInfo.in_pool(self, args)
    for _, v in ipairs(G.playing_cards) do
        if v.ability.effect == "Steel Card" then
            return true
        end
    end
end

function jokerInfo.calculate(self, card, context)
    if context.individual and context.cardarea == G.play and not card.debuff then
        if context.other_card.ability.effect == "Steel Card" then
            return {
                x_mult = card.ability.extra.x_mult,
                card = card
            }
        end
    end
end

return jokerInfo