local consumInfo = {
    name = 'The Osteoporosis Dance',
    key = 'osteo',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        extra = {
            hand_mod = 1,
            runtime = 3,
            uses = 0,
        },
        activated = false,
        destroyed = false,
    },
    origin = {
        category = 'rlm',
        sub_origins = {
            'rlm_wotw',
        },
        custom_color = 'rlm'
    },
    artist = 'Kekulism',
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    return { vars = { card.ability.runtime-card.ability.uses } }
end

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.setting_blind and not card.getting_sliced and not card.debuff then
        ease_hands_played(1)
        card.ability.uses = card.ability.uses+1
        if to_big(card.ability.uses) >= to_big(card.ability.runtime) then
            ArrowAPI.vhs.destroy_tape(card)
            card.ability.destroyed = true
        end
        return {
            card = card,
            message = localize{type = 'variable', key = 'a_plus_hand', vars = {1}},
            colour = G.C.BLUE
        }
    end
end

function consumInfo.can_use(self, card)
    if to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit) or card.area == G.consumeables then return true end
end

return consumInfo