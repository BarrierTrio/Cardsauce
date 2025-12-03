local consumInfo = {
    name = "Ryan's Babe",
    key = 'ryansbabe',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        activated = false,
        destroyed = false,
        extra = {
            runtime = 3,
            uses = 0,
        },
    },
    origin = 'rlm',
    artist = 'yunkie101'
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_bonus
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    return { vars = { card.ability.runtime-card.ability.uses } }
end

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.before and not card.debuff and not context.blueprint and ArrowAPI.game.hand_contains_ranks(context.scoring_hand, {12}) then
        for i, v in ipairs(context.scoring_hand) do
            if v:get_id() == 12 and v.ability.effect == "Base" and not v.debuff and not card.ability.destroyed then
                v:set_ability(G.P_CENTERS.m_bonus, nil, true)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        v:juice_up()
                        return true
                    end
                }))
            end
        end
        return {
            message = localize('k_ryansbabe'),
            colour = G.C.CHIPS,
            card = card
        }
    end
    local bad_context = context.repetition or context.individual or context.blueprint
    if context.after and not card.ability.destroyed and card.ability.activated and not bad_context then
        card.ability.uses = card.ability.uses+1
        if to_big(card.ability.uses) >= to_big(card.ability.runtime) then
            ArrowAPI.vhs.destroy_tape(card)
            card.ability.destroyed = true
        end
    end
end

function consumInfo.can_use(self, card)
    if to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit) or card.area == G.consumeables then return true end
end

return consumInfo