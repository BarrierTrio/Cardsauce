local consumInfo = {
    name = 'Suburban Sasquatch',
    key = 'suburbansasquatch',
    set = "VHS",
    runtime = 2,
    cost = 3,
    alerted = true,
    config = {
        extra = {
            runtime = 2,
        },
    },
    origin = {
        category = 'rlm',
        sub_origins = {
            'rlm_botw',
        },
        custom_color = 'rlm'
    },
    artist = 'AlizarinRed'
}

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.final_scoring_step then
        if not context.blueprint then
            ArrowAPI.vhs.destroy_tape(card)
        end

        G.E_MANAGER:add_event(Event({
            func = function()
                for i, v in ipairs(context.scoring_hand) do
                    assert(SMODS.modify_rank(v, card.ability.extra.inc))
                    v:juice_up()
                end
                card:juice_up()
                return true
            end
        }))

        return {
            message = localize('k_upgrade_ex'),
            card = card
        }
    end
end

return consumInfo