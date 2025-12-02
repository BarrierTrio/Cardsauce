local consumInfo = {
    name = 'Low Blow',
    key = 'lowblow',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        activated = false,
        destroyed = false,
        extra = {
            retrigger = 4,
            runtime = 2,
            uses = 0,
        }
    },
    origin = 'rlm',
    artist = 'yunkie101'
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    return { vars = { card.ability.extra.retrigger, card.ability.extra.runtime-card.ability.extra.uses } }
end

local function get_lowest_card(hand)
    local lowest_card = nil
    local lowest_value = math.huge
    for _, v in ipairs(hand) do
        if v.base and v.base.nominal and v.base.nominal <= lowest_value then
            lowest_value = v.base.nominal
            lowest_card = v
        end
    end
    return lowest_card
end

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.cardarea == G.play and context.repetition and not context.repetition_only then
        local lowest = get_lowest_card(context.scoring_hand)
        if context.other_card == lowest then
            return {
                message = 'Again!',
                repetitions = card.ability.extra.retrigger,
                card = card
            }
        end
    end
    local bad_context = context.repetition or context.individual or context.blueprint
    if context.after and not card.ability.destroyed and card.ability.activated and not bad_context then
        card.ability.extra.uses = card.ability.extra.uses+1
        if to_big(card.ability.extra.uses) >= to_big(card.ability.extra.runtime) then
            ArrowAPi.vhs.destroy_tape(card)
            card.ability.destroyed = true
        end
    end
end

function consumInfo.can_use(self, card)
    if to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit) or card.area == G.consumeables then return true end
end

return consumInfo