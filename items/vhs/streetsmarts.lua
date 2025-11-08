local consumInfo = {
    name = 'Street Smarts: Straight Talk For Kids, Teens & Parents',
    key = 'streetsmarts',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        activated = false,
        destroyed = false,
        extra = {
            mult = 20,
            runtime = 3,
            uses = 0,
        },
    },
    origin = {
        'rlm',
        'rlm_j',
        color = 'rlm'
    },
    artist = 'yumz'
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    return { vars = { card.ability.extra.mult, card.ability.extra.runtime-card.ability.extra.uses } }
end
function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.joker_main and G.GAME.current_round.hands_left == 0 then
        return {
            mult = card.ability.extra.mult
        }
    end
    local bad_context = context.repetition or context.individual or context.blueprint
    if card.ability.activated and context.end_of_round and not card.debuff and not bad_context then
        card.ability.extra.uses = card.ability.extra.uses+1
        if to_big(card.ability.extra.uses) >= to_big(card.ability.extra.runtime) then
            G.FUNCS.destroy_tape(card)
            card.ability.destroyed = true
        end
    end
end

function consumInfo.can_use(self, card)
    if to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit) or card.area == G.consumeables then return true end
end

return consumInfo