SMODS.Sound({ key = "vhsopen", path = "vhsopen.ogg"})
SMODS.Sound({ key = "vhsclose", path = "vhsclose.ogg"})
SMODS.UndiscoveredSprite{
    key = "VHS",
    atlas = "arrow_undiscovered",
    pos = { x = 0, y = 0 }
}
SMODS.ConsumableType{
    key = "VHS",
    primary_colour = G.C.VHS,
    secondary_colour = G.C.VHS,
    collection_rows = { 7, 6 },
    shop_rate = 0,
    loc_txt = {},
    default = "c_arrow_blackspine",
    can_stack = false,
    can_divide = false,
}


--- Helper functions for VHS Tapes
ArrowAPI.vhs = {
    --- Returns the first non-debuffed VHS Tape with a specified key, nil if none qualify
    --- @return table | nil # Balatro card object of activated VHS Tape, or nil
    find_activated_tape = function(key)
        local tapes = SMODS.find_card(key)
        if tapes and #tapes > 0 then
            for _, v in ipairs(tapes) do
                if not v.debuff and v.ability.activated then
                    return v
                end
            end
        end

        return nil
    end,

    --- Returns the number of VHS tapes in your consumable slots
    --- @return number # Count of current VHS tapes
    get_vhs_count = function()
        if not G.consumeables then return 0 end
        local count = 0
        for i, v in ipairs(G.consumeables.cards) do
            if v.ability.set == "VHS" then
                count = count+1
            end
        end
        return count
    end,

    --- Handler for VHS Tape activation feedback
    --- @param card Card Balatro Card object of VHS tape to activate
    tape_activate = function(card)
        if not card.ability.activation then return end

        if card.ability.activated then
            card.ability.activated = false
            play_sound('arrow_vhsclose', 0.9 + math.random()*0.1, 0.4)
        else
            card.ability.activated = true
            play_sound('arrow_vhsopen', 0.9 + math.random()*0.1, 0.4)
        end
    end,

    --- Destroys a VHS tape and calls all relevant contexts
    --- @param card Card Balatro Card object of VHS tape to destroy
    --- @param delay_time number Event delay in seconds
    --- @param ach string | nil Achievement type key, will check for achievement unlock if not nil
    --- @param silent boolean | nil Plays tarot sound effect on destruction if true
    --- @param loc_message string | nil Custom loc string for destruction message, defaults to 'k_vhs_destroyed'
    destroy_tape = function(card, delay_time, ach, silent, loc_message)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = delay_time,
            func = function()
                attention_text({
                    text = localize(loc_message or 'k_vhs_destroyed'),
                    scale = 1,
                    hold = 0.5,
                    backdrop_colour = G.C.VHS,
                    align = 'bm',
                    major = card,
                    offset = {x = 0, y = 0.05*card.T.h}
                })
                play_sound('generic1')

                delay(0.15)

                if not silent then
                    play_sound('tarot1')
                end
                card.T.r = -0.1
                card:juice_up(0.3, 0.4)
                card.states.drag.is = true
                card.children.center.pinch.x = true

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    blockable = false,
                    func = function()
                        if card.config.center.activate and type(card.config.center.activate) == 'function' then
                            card.config.center.activate(card.config.center, card, false)
                        end

                        SMODS.calculate_context({vhs_death = true, card = card})

                        card:remove()
                        return true
                    end
                }))
                if ach then
                    check_for_unlock({ type = ach })
                end
                return true
            end
        }))
    end
}