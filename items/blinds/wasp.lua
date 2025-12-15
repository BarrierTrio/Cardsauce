local blindInfo = {
    name = "The Wasp",
    atlas = 'blinds',
    pos = {x = 0, y = 7},
    boss_colour = HEX('ffd44b'),
    dollars = 5,
    mult = 2,
    vars = {},
    debuff = {},
    boss = {min = 2, max = 10},
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    }
}

function blindInfo.defeat(self)
    check_for_unlock({ type = "defeat_wasp" })
end

local function american_hornet()
    if not G.GAME.blind.disabled and G.GAME.blind.name == 'The Wasp' then
        return true
    elseif G.GAME.fnwk_extra_blinds then
        for _, v in ipairs(G.GAME.fnwk_extra_blinds) do
            if not v.disabled and v.name == 'The Wasp' then
                return true
            end
        end
    end

    return false
end

local ref_eval = eval_card
function eval_card(card, context)
    local ret = {}
    local post_trig = {}
    if (context.repetition or context.retrigger_joker) and american_hornet() then return ret, post_trig end
    return ref_eval(card, context)
end

local ref_calc_retrig = SMODS.calculate_retriggers
SMODS.calculate_retriggers = function(card, context, _ret)
    local retriggers = {}
    if (context.repetition or context.retrigger_joker) and american_hornet() then return retriggers end
    return ref_calc_retrig(card, context, _ret)
end

function blindInfo.defeat(self)

end

return blindInfo