local consumInfo = {
    name = 'The Room',
    key = 'theroom',
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
            blind_mod = 0.15
        }
    },
    artist = {'MightyKingWario', 'yunkie101'}
}


function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
    return { vars = { 100*card.ability.extra.blind_mod, card.ability.extra.runtime-card.ability.extra.uses } }
end

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.setting_blind and not card.getting_sliced and not card.debuff then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                local new_chips = math.floor(G.GAME.blind.chips * (1-card.ability.extra.blind_mod))
                G.GAME.blind:wiggle()
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_theroom'), colour = G.C.IMPORTANT})
                G.E_MANAGER:add_event(Event({
                    trigger = 'ease',
                    blocking = false,
                    ref_table = G.GAME.blind,
                    ref_value = 'chips',
                    ease_to = new_chips,
                    delay =  0.5,
                    func = (function(t) G.GAME.blind.chip_text = number_format(G.GAME.blind.chips); return math.floor(t) end)
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.5,
                    func = function()
                        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                        card.ability.extra.uses = card.ability.extra.uses+1
                        if to_big(card.ability.extra.uses) >= to_big(card.ability.extra.runtime) then
                            G.FUNCS.destroy_tape(card)
                            card.ability.destroyed = true
                        end
                        return true
                    end
                }))
                return true
            end
        }))
    end
end

function consumInfo.can_use(self, card)
    if to_big(#G.consumeables.cards) < to_big(G.consumeables.config.card_limit) or card.area == G.consumeables then return true end
end

return consumInfo