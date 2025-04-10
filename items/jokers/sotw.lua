local jokerInfo = {
    name = "Stand of the Week",
    config = {
        unlock = 10,
        extra = {
            x_mult = 1,
            x_mult_mod = 0.25
        },
    },
    rarity = 3,
    cost = 7,
    unlocked = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "joel",
    part = 'stardust',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
    return { vars = {card.ability.extra.x_mult_mod, card.ability.extra.x_mult} }
end

function jokerInfo.locked_loc_vars(self, info_queue, card)
    return { vars = { card.ability.unlock, G.DISCOVER_TALLIES.stands.tally } }

end

function jokerInfo.check_for_unlock(self, args)
    if args.type == 'discover_amount' then
        if G.DISCOVER_TALLIES.stands.tally >= self.config.unlock then
            return true
        end
    end
end

function jokerInfo.calculate(self, card, context)
    if card.ability.extra.x_mult > 1 and context.joker_main and context.cardarea == G.jokers then
        return {
            message = localize{type='variable',key='a_xmult',vars={to_big(card.ability.extra.x_mult)}},
            Xmult_mod = card.ability.extra.x_mult,
        }
    end
end

function jokerInfo.update(self, card, dt)
    local stands_obtained = 0
    for k, v in pairs(G.GAME.consumeable_usage) do if v.set == 'Stand' then stands_obtained = stands_obtained + 1 end end
    card.ability.extra.x_mult = 1 + (card.ability.extra.x_mult_mod*stands_obtained)
end

return jokerInfo


