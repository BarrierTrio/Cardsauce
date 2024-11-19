local jokerInfo = {
    name = 'The Purple Joker',
    config = {},
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_TAGS.tag_charm
end

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and context.before and not card.debuff then
        local purp = true
        for k, v in ipairs(context.full_hand) do
            purp = purp and v.base.suit == 'Spades'
        end
        if purp then
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_charm'), colour = G.C.SECONDARY_SET.Tarot})
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                blocking = false,
                func = (function()
                    add_tag(Tag('tag_charm'))
                    play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                    return true
                end)
            }))
        end
    end
end

return jokerInfo