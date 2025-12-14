local consumInfo = {
    name = 'Chopping Mall',
    atlas = 'vhs',
	pos = {x = 7, y = 0},
    set = "VHS",
    runtime = 3,
    cost = 3,
    alerted = true,
    config = {},
    origin = {
        category = 'rlm',
        sub_origins = {
            'rlm_botw',
        },
        custom_color = 'rlm'
    },
    artist = 'MightyKingWario'
}

function consumInfo.calculate(self, card, context)
    if not card.ability.activated then return end

    if context.after and card.ability.extra.csau_chopping_this_hand and not context.blueprint then
        card.ability.extra.csau_chopping_this_hand = nil
        ArrowAPI.vhs.run_tape(card)
        return
    end

    if not (context.repetition and context.cardarea == G.hand)
    or not (next(context.card_effects[1]) or #context.card_effects > 1) then
        return
    end

    card.ability.extra.csau_chopping_this_hand = true

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        blocking = false,
        func = function()
            card:juice_up()
            return true
        end
    }))

    return {
        message = localize('k_again_ex'),
        repetitions = 1,
        card = card
    }
end

return consumInfo