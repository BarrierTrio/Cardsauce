local consumInfo = {
    name = 'The Room',
    set = "VHS",
    runtime = 2,
    cost = 3,
    config = {
        extra = {
            blind_mod = 0.15
        }
    },
    artist = {'MightyKingWario', 'yunkie101'}
}

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = { 100*card.ability.extra.blind_mod } }
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if card.ability.activated and context.setting_blind then
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
                if not context.blueprint then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.5,
                        func = function()
                            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                            ArrowAPI.vhs.run_tape(card)
                            return true
                        end
                    }))
                end

                return true
            end
        }))
    end
end

return consumInfo