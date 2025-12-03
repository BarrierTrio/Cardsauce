local consumInfo = {
    name = 'Blood Debts',
    set = "VHS",
    runtime = 3,
    cost = 3,
    blueprint_compat = false,
    config = {
        extra = {
            interest = 1,
        }
    },
    origin = {
        category = 'rlm',
        sub_origins = {
            'rlm_botw',
        },
        custom_color = 'rlm'
    },
    artist = 'yunkie101'
}

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.interest } }
end

function consumInfo.calculate(self, card, context)
    if card.debuff or context.blueprint then return end

    if card.ability.activated and context.starting_shop then
        ArrowAPI.vhs.run_tape(card)
    end
end

function consumInfo.activate(self, card, on)
    if on then
        G.GAME.interest_amount = G.GAME.interest_amount + card.ability.extra.interest
    else
        G.GAME.interest_amount = G.GAME.interest_amount - card.ability.extra.interest
    end
end

return consumInfo