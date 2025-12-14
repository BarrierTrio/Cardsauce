local consumInfo = {
    name = 'California Big Hunks',
    atlas = 'vhs',
	pos = {x = 1, y = 1},
    set = "VHS",
    runtime = 3,
    cost = 3,
    config = {},
    blueprint_compat = false,
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'rlm',
            'rlm_j',
        },
        custom_color = 'rlm'
    },
    artist = 'FenixSeraph'
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_mult
end

function consumInfo.calculate(self, card, context)
    if card.debuff or context.blueprint then return end

    if card.ability.activated and context.before and ArrowAPI.game.hand_contains_ranks(context.scoring_hand, {13}) then
        for i, v in ipairs(context.scoring_hand) do
            if v:get_id() == 13 and v.config.center.key == 'c_base' and not v.debuff then
                v:set_ability(G.P_CENTERS.m_mult, nil, true)
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        v:juice_up()
                        return true
                    end
                }))
            end
        end

        return {
            message = localize('k_bighunks'),
            colour = G.C.MULT,
            card = card
        }
    end

    if context.after and card.ability.activated then
        ArrowAPI.vhs.run_tape(card)
    end
end

return consumInfo