local jokerInfo = {
    name = "Movin' Right Along",
    atlas = 'jokers',
	pos = {x = 1, y = 8},
    config = {
        dollars_before = 0,
        extra = {
            x_mult = 1,
            x_mult_mod = 0.5,
        }
    },
    rarity = 2,
    cost = 5,
    unlocked = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    origin = 'cardsauce',
    artist = 'Jazz_Jen'
}

function jokerInfo.check_for_unlock(self, args)
    return args.type == "continue_game"
end

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult_mod } }
end

function jokerInfo.calculate(self, card, context)
    if context.starting_shop and not context.blueprint then
        card.ability.dollars_before = G.GAME.dollars
    end

    if context.ending_shop and not context.blueprint then
        local same_dollars = G.GAME.dollars == card.ability.dollars_before
        card.ability.dollars_before = 0
        if not card.debuff and same_dollars then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "x_mult",
                scalar_value = "x_mult_mod",
                message_key = 'a_xmult',
                message_colour = G.C.MULT
            })
        end
    end

    if context.joker_main and to_big(card.ability.extra.x_mult) > to_big(1) then
        return {
            x_mult = card.ability.extra.x_mult,
        }
    end
end

return jokerInfo
