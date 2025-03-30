local jokerInfo = {
    name = 'Jokers of Circumstance',
    config = {
        extra = {
            chips = 50,
            mult = 5
        }
    },
    rarity = 1,
    cost = 4,
    unlocked = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "vinny",
}

function jokerInfo.check_for_unlock(self, args)
    if args.type == "unlock_villains" then
        return true
    end
end

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
    return { vars = {card.ability.extra.chips, card.ability.extra.mult}}
end

function jokerInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_villains" })
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main then
        local play_more_than = 0
        local most_played = context.scoring_name
        for k, v in pairs(G.GAME.hands) do
            if v.played >= play_more_than and v.visible then
                play_more_than = v.played
                most_played = k
            end
        end
        if most_played == context.scoring_name then
            SMODS.eval_this(card, {
                message = localize{type = 'variable', key = 'a_chips', vars = {to_big(card.ability.extra.chips)}},
                chip_mod = card.ability.extra.chips,
                colour = G.C.CHIPS
            })
            SMODS.eval_this(card, {
                message = localize{type = 'variable', key = 'a_mult', vars = {to_big(card.ability.extra.mult)}},
                mult_mod = card.ability.extra.mult,
                colour = G.C.MULT
            })
        end
    end
end

return jokerInfo