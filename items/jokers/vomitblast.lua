local jokerInfo = {
    name = "VOMIT BLAST",
    atlas = 'jokers',
	pos = {x = 0, y = 15},
    config = {
        extra = {
            mult = 0,
            mult_mod = 6,
        },
    },
    rarity = 1,
    cost = 4,
    unlocked = false,
    unlock_condition = {num = 30},
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    has_shiny = true,
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'joel',
        },
        custom_color = 'joel'
    },
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult } }
end

function jokerInfo.check_for_unlock(self, args)
    if args.type == "discover_grey" then
        return true
    end
    if args.type == 'discard_custom' then
        G.GAME.vomit_blast_discards = (G.GAME.vomit_blast_discards or 0) + #args.cards
        return to_big(G.GAME.vomit_blast_discards) >= to_big(self.unlock_condiiton.num)
    end

    if args.type == 'round_win' then
        G.GAME.vomit_blast_discards = 0
    end
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if to_big(card.ability.extra.mult) > to_big(0) and context.joker_main then
        return {
            mult = card.ability.extra.mult,
        }
    end

    if context.blueprint then return end

    if context.pre_discard and #context.full_hand >= 5 then
        local scale_table = {mult_mod = math.floor(#context.full_hand / 5) * card.ability.extra.mult_mod}
        SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = "mult",
            scalar_table = scale_table,
            scalar_value = "mult_mod",
            message_key = 'a_mult',
            message_colour = G.C.MULT
        })
    end

    if context.end_of_round and to_big(card.ability.extra.mult) > to_big(0) then
        card.ability.extra.mult = 0
        return {
            message = localize('k_reset'),
            colour = G.C.MULT
        }
    end
end

return jokerInfo