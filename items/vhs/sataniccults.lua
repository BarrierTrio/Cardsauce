local consumInfo = {
    name = 'Law Enforcement Guide to Satanic Cults',
    key = 'sataniccults',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        activated = false,
        destroyed = false,
        extra = {
            runtime = 2,
            uses = 0,
            xmult = 2,
        }
    },
    origin = {
        'rlm',
        'rlm_wotw',
        color = 'rlm'
    }
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku } }
    return { vars = { card.ability.extra.xmult, card.ability.extra.runtime-card.ability.extra.uses } }
end

function consumInfo.set_ability(self, card, initial, delay_sprites)
    if next(SMODS.find_card("c_csau_moodyblues")) then
        card.ability.extra.runtime = card.ability.extra.runtime*2
    end
end

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.individual and context.cardarea == G.hand then
        if SMODS.has_enhancement(context.other_card, 'm_gold') then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
    local bad_context = context.repetition or context.individual or context.blueprint
    if context.after and not card.ability.destroyed and card.ability.activated and not bad_context then
        card.ability.extra.uses = card.ability.extra.uses+1
        if card.ability.extra.uses >= card.ability.extra.runtime then
            G.FUNCS.destroy_tape(card)
            card.ability.destroyed = true
        end
    end
end

function consumInfo.can_use(self, card)
    if #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables then return true end
end

return consumInfo