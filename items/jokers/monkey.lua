local jokerInfo = {
    name = "Monkey Mondays",
    config = {
        extra = {
            mult = 5,
            prob = 6,
        },
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "joel",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.lyzerus } }
    return { vars = { card.ability.extra.mult, G.GAME.probabilities.normal, card.ability.extra.prob } }
end

function jokerInfo.calculate(self, card, context)
    if context.individual and context.cardarea == G.play and not card.debuff then
        return {
            mult = card.ability.extra.mult,
            card = card
        }
    end
    if context.destroying_card and not context.blueprint then
        if pseudorandom('monkeymode') < G.GAME.probabilities.normal / card.ability.extra.prob then
            G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
                play_sound('whoosh2', math.random()*0.2 + 0.9,0.5)
                play_sound('crumple'..math.random(1, 5), math.random()*0.2 + 0.9,0.5)
                return true end }))
            return true
        end
    end
end

return jokerInfo