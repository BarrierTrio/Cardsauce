local jokerInfo = {
    name = "VOMIT BLAST",
    config = {
        extra = {
            mult = 0,
            mult_mod = 6,
        },
    },
    rarity = 1,
    cost = 4,
    unlocked = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    has_shiny = true,
    origin = 'joel',
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

local goal = 30

function jokerInfo.check_for_unlock(self, args)
    if args.type == "discover_grey" then
        return true
    end
    if args.type == 'discard_custom' then
        G.GAME.vomit_blast_discards = G.GAME.vomit_blast_discards or 0
        G.GAME.vomit_blast_discards = G.GAME.vomit_blast_discards + #args.cards
        return to_big(G.GAME.vomit_blast_discards) >= to_big(goal)
    end
    if args.type == 'round_win' then
        G.GAME.vomit_blast_discards = 0
    end
end

function jokerInfo.calculate(self, card, context)
    if context.pre_discard and not context.blueprint and #context.full_hand >= 5 then
        local mod = math.floor(#context.full_hand / 5)
        card.ability.extra.mult = card.ability.extra.mult + ( card.ability.extra.mult_mod * mod )
        G.E_MANAGER:add_event(Event({ func = function()
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}}})
            return true
        end}))
    end
    if to_big(card.ability.extra.mult) > to_big(0) and context.joker_main and context.cardarea == G.jokers then
        return {
            mult = card.ability.extra.mult,
        }
    end
    if context.end_of_round and not context.blueprint and to_big(card.ability.extra.mult) > to_big(0) then
        card.ability.extra.mult = 0
        return {
            message = localize('k_reset'),
            colour = G.C.RED
        }
    end
end

return jokerInfo