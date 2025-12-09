local consumInfo = {
    name = 'SOS',
    set = "VHS",
    runtime = 3,
    cost = 3,
    alerted = true,
    config = {
        extra = {
            x_mult = 3,
            prob = 2,
        },
    },
    origin = {
        category = 'rlm',
        sub_origins = {
            'rlm_wotw',
        },
        custom_color = 'rlm'
    },
    artist = 'yunkie101'
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    local num, dom = SMODS.get_probability_vars(card, 1, card.ability.extra.prob, 'csau_sos')
    return { vars = { num, dom, card.ability.extra.x_mult, card.ability.runtime-card.ability.uses } }
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.joker_main and card.ability.activated and SMODS.pseudorandom_probability(card, 'csau_sos', 1, card.ability.extra.prob) then
        return {
            x_mult = card.ability.extra.x_mult,
            card = card
        }
    end

    if context.after and card.ability.activated and not context.blueprint then
        ArrowAPI.vhs.run_tape(card)
    end
end

return consumInfo