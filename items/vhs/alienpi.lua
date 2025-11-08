local consumInfo = {
    name = 'Alien Private Eye',
    key = 'alienpi',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        activated = false,
        destroyed = false,
        extra = {
            runtime = 100,
            uses = 0,
            chance_mod = 1,
            chance = 0,
            rate = 100,
            x_mult = 1.25,
        },
    },
    origin = {
        'rlm',
        'rlm_botw',
        color = 'rlm'
    },
    artist = 'Gongalicious'
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    local num, dom = SMODS.get_probability_vars(card, card.ability.extra.chance, card.ability.extra.rate, 'csau_alienpi')
    return { vars = { card.ability.extra.x_mult, card.ability.extra.chance_mod, num, dom, card.ability.extra.runtime - card.ability.extra.uses } }
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if card.ability.activated and context.individual and context.cardarea == G.play then
        card.ability.extra.uses = math.min(card.ability.extra.runtime, card.ability.extra.uses + 1)
        if to_big(card.ability.extra.uses) < to_big(card.ability.extra.runtime) then
            card.ability.extra.chance = card.ability.extra.chance + 1
            return {
                x_mult = card.ability.extra.x_mult,
                card = card
            }
        end
    end

    if context.after and to_big(card.ability.extra.uses) >= to_big(card.ability.extra.runtime) then
        G.E_MANAGER:add_event(Event({
            func = function()
                G.STATE = G.STATES.GAME_OVER
                G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
                G:save_settings()
                G.FILE_HANDLER.force = true
                G.STATE_COMPLETE = false
                return true
            end
        }))
    end

    if context.selling_self and SMODS.pseudorandom_probability(card, 'csau_alienpi', card.ability.extra.chance, card.ability.extra.rate) then
        G.E_MANAGER:add_event(Event({
            func = function()
                G.STATE = G.STATES.GAME_OVER
                G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
                G:save_settings()
                G.FILE_HANDLER.force = true
                G.STATE_COMPLETE = false
                return true
            end
        }))
    end
end

function consumInfo.can_use(self, card)
    if to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit) or card.area == G.consumeables then return true end
end

return consumInfo