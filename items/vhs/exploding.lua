local consumInfo = {
    name = 'Exploding Varmints',
    set = "VHS",
    runtime = 2,
    cost = 3,
    config = {},
    origin = {
        category = 'rlm',
        sub_origins = {
            'rlm_wotw',
        },
        custom_color = 'rlm'
    },
    artist = 'HunnyByte'
}

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if card.ability.activated and context.setting_blind then
        local mod = G.GAME.current_round.hands_left - 1
        ease_hands_played(-mod)
        ease_discard(mod)

        if not context.blueprint then
            ArrowAPI.vhs.run_tape(card)
        end


        return {
            card = card,
            message = localize{type = 'variable', key = 'a_plus_discard', vars = {mod}},
            colour = G.C.RED
        }
    end
end

return consumInfo