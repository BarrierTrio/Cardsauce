local consumInfo = {
    name = 'Low Blow',
    set = "VHS",
    runtime = 2,
    cost = 3,
    config = {
        extra = {
            retrigger = 4,
        }
    },
    origin = 'rlm',
    artist = 'yunkie101'
}


function consumInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.retrigger } }
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
    if card.ability.activated and context.cardarea == G.play and context.repetition then
        local lowest = get_lowest_card(context.scoring_hand)
        if context.other_card == lowest then
            return {
                message = 'Again!',
                repetitions = card.ability.extra.retrigger,
                card = card
            }
        end
    end

    if context.after and card.ability.activated and not context.blueprint then
        ArrowAPI.vhs.run_tape(card)
    end
end

return consumInfo