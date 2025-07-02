local consumInfo = {
    name = "Wayne's World VCR Board Game",
    key = 'wwvcr',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        extra = {
            chips = 100,
            runtime = 3,
            uses = 0,
        },
        activated = false,
        destroyed = false,
    },
    origin = {
        'vinny',
        'vinny_wotw',
        color = 'vinny'
    }
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.yumz } }
    return { 
        vars = { card.ability.extra.chips, card.ability.extra.runtime-card.ability.extra.uses },
        key = self.key..(csau_config['detailedDescs'] and '_detailed' or '')
    }
end

function consumInfo.calculate(self, card, context)
    if context.joker_main and card.ability.activated then
        return {
            chips = card.ability.extra.chips
        }
    end
    local bad_context = context.repetition or context.individual or context.blueprint
    if context.after and not card.ability.destroyed and card.ability.activated and not bad_context then
        card.ability.extra.uses = card.ability.extra.uses+1
        if to_big(card.ability.extra.uses) >= to_big(card.ability.extra.runtime) then
            check_for_unlock({ type = "monkey_butt" })
            G.FUNCS.destroy_tape(card)
            card.ability.destroyed = true
        end
    end
end

function consumInfo.can_use(self, card)
    if to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit) or card.area == G.consumeables then return true end
end

return consumInfo