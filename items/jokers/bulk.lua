local jokerInfo = {
    name = "Bulkin' The Mouscles",
    config = {
        extra = {
            x_mult = 1,
            x_mult_mod = 0.1,
        },
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    has_shiny = true,
    streamer = "joel",
    artist = 'Drawer_Mary'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult_mod, card.ability.extra.x_mult } }
end

-- TODO: reimplement bulk using contexts

function jokerInfo.calculate(self, card, context)
    if context.change_rank and context.rank_increase then
        SMODS.scale_card(self, {
            ref_table = self.ability.extra,
            ref_value = "x_mult",
            scalar_value = "x_mult_mod",
            message_colour = G.C.RED
        })
    end

    if context.joker_main and to_big(card.ability.extra.x_mult) > to_big(1) then
        return {
            xmult = card.ability.extra.x_mult
        }
    end
end

return jokerInfo