local jokerInfo = {
    name = 'Dripping Joker',
    atlas = 'jokers',
	pos = {x = 3, y = 9},
    config = {},
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    origin = 'cardsauce',
    artist = 'Alli'
}

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.before and G.GAME.current_round.hands_played == 0 then
        local pool = {}
        for i, v in ipairs(G.hand.cards) do
            if not v.csau_drippy_flagged and v.config.center.key == 'c_base' and not v.debuff then
                table.insert(pool, v)
            end
        end

        if #pool > 0 then
            local rand_card = pseudorandom_element(pool, pseudoseed('stickybytylerthecreator'))
            rand_card.csau_drippy_flagged = true
            G.E_MANAGER:add_event(Event({
                func = function()
                    rand_card:set_ability(pseudorandom_element(G.P_CENTER_POOLS['Enhanced'], pseudoseed('whothefuckisdrippysaidvinny')), nil, true)
                    rand_card:juice_up()
                    rand_card.csau_drippy_flagged = nil
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