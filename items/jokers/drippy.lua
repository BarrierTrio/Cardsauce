local jokerInfo = {
    name = 'Dripping Joker',
    config = {},
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "other",
    artist = 'Alli'
}

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and context.before and not card.debuff and G.GAME.current_round.hands_played == 0 and not context.debuffed then

        local enhancements = {}
        for k, v in pairs(G.P_CENTERS) do if v.set == "Enhanced" then table.insert(enhancements, v) end end
        for k, v in pairs (SMODS.Centers) do if v.set == "Enhanced" then table.insert(enhancements, v) end end

        local pool = {}
        for i, v in ipairs(G.hand.cards) do
            if v.ability.effect == "Base" then
                table.insert(pool, v)
            end
        end
        if #pool > 0 then
            local rand_card = pseudorandom_element(pool, pseudoseed('stickybytylerthecreator'))
            rand_card:set_ability(pseudorandom_element(enhancements, pseudoseed('whothefuckisdrippysaidvinny')), nil, true)
            G.E_MANAGER:add_event(Event({
                func = function()
                    rand_card:juice_up()
                    return true
                end
            }))
            return {
                message = localize('k_enhanced'),
                card = context.blueprint_card or card,
            }
        end
    end
end

return jokerInfo