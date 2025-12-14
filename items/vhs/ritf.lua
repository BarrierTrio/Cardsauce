local consumInfo = {
    name = "Robot in the Family",
    atlas = 'vhs',
	pos = {x = 0, y = 4},
    key = 'ritf',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        activated = false,
        destroyed = false,
        extra = {
            runtime = 5,
            uses = 0,
            pi_index = 1,
        },
    },
    origin = {
        category = 'rlm',
        sub_origins = {
            'rlm_botw',
        },
        custom_color = 'rlm'
    },
    artist = 'yunkie101'
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    return {
        vars = { card.ability.runtime-card.ability.uses },
    }
end

local pi_digits = "314159265358979323846264338327950288419716939937510582097494459230781640628620899862803482534211706798214808651328230664709384460955058223172"

local function get_pi_digit(i)
    local len = #pi_digits
    local index = ((i - 1) % len) + 1 -- Wrap around to 1-based index
    return tonumber(pi_digits:sub(index, index))
end

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.individual and not context.end_of_round then
        if context.cardarea == G.play then
            card.ability.extra.pi_index = card.ability.extra.pi_index+1
            return {
                mult = get_pi_digit(card.ability.extra.pi_index-1)
            }
        elseif context.cardarea == G.hand then
            card.ability.extra.pi_index = card.ability.extra.pi_index+1
            return {
                chips = get_pi_digit(card.ability.extra.pi_index-1)
            }
        end
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