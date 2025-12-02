local consumInfo = {
    name = 'Suburban Sasquatch',
    key = 'suburbansasquatch',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        activated = false,
        destroy = false,
        extra = {
            inc = 1,
            runtime = 2,
            uses = 0,
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


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    return { vars = { card.ability.extra.inc, card.ability.extra.runtime-card.ability.extra.uses } }
end

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.final_scoring_step then
        G.E_MANAGER:add_event(Event({
            func = function()
                for i, v in ipairs(context.scoring_hand) do
                    assert(SMODS.modify_rank(v, card.ability.extra.inc))
                    v:juice_up()
                end
                card:juice_up()
                card.ability.extra.uses = card.ability.extra.uses+1
                if to_big(card.ability.extra.uses) >= to_big(card.ability.extra.runtime) then
                    ArrowAPi.vhs.destroy_tape(card)
                    card.ability.destroyed = true
                end
                return true
            end
        }))
        return {
            message = localize('k_upgrade_ex'),
            card = card
        }
    end
end

function consumInfo.can_use(self, card)
    if to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit) or card.area == G.consumeables then return true end
end

return consumInfo