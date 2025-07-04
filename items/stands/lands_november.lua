local consumInfo = {
    name = 'November Rain',
    set = 'csau_Stand',
    config = {
        aura_colors = { '43b7abDC', '2e8cfaDC' },
        stand_mask = true,
        extra = {
            max_rank = 9,
            chips = 9,
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    hasSoul = true,
    part = 'lands',
    blueprint_compat = true
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } }
    return { vars = {card.ability.extra.max_rank, card.ability.extra.chips}}
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.modify_scoring_hand and not context.blueprint and not context.retrigger_joker
    and not SMODS.has_no_rank(context.other_card) and to_big(context.other_card.base.nominal) <= to_big(9) then
        return {
            no_retrigger = true,
            add_to_hand = true
        }
    end

    if context.individual and context.cardarea == G.play and not SMODS.has_no_rank(context.other_card)
    and to_big(context.other_card.base.nominal) <= to_big(9) then
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                G.FUNCS.csau_flare_stand_aura(flare_card, 0.50)
            end,
            extra = {
                card = flare_card,
                chips = card.ability.extra.chips
            }
        }
    end
end


return consumInfo