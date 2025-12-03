local consumInfo = {
    name = "Ryan's Babe",
    set = "VHS",
        runtime = 3,
    cost = 3,
    blueprint_compat = false,
    config = {},
    origin = 'rlm',
    artist = 'yunkie101'
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_bonus
end

function consumInfo.calculate(self, card, context)
    if card.debuff or context.blueprint then return end

    if card.ability.activated and context.before and ArrowAPI.game.hand_contains_ranks(context.scoring_hand, {12}) then
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


    if context.after and card.ability.activated then
        ArrowAPI.vhs.run_tape(card)
    end
end

return consumInfo