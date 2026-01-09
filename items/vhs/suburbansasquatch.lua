local consumInfo = {
    name = 'Suburban Sasquatch',
    atlas = 'vhs',
	pos = {x = 1, y = 4},
    set = "VHS",
    runtime = 2,
    cost = 6,
    alerted = true,
    config = {
        extra = {
            inc = 2
        },
    },
    origin = {
        category = 'rlm',
        sub_origins = {
            'rlm_botw',
        },
        custom_color = 'rlm'
    },
    artist = 'AlizarinRed'
}

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.inc}}
end

function consumInfo.calculate(self, card, context)
    if card.ability.activated and context.after then
        local change_cards = {}
        for i, v in ipairs(context.scoring_hand) do
            SMODS.modify_rank(v, card.ability.extra.inc, true)
            change_cards[#change_cards+1] = {card = v, card_key = v.config.card_key}
        end

        for _, v in ipairs(change_cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    v.card:flip()
                    play_sound('card1')
                    v.card:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end

        for _, v in ipairs(change_cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    v.card:set_sprites(nil, G.P_CARDS[v.card_key])
                    return true
                end
            }))
        end

        -- do flip back over
        for _, v in ipairs(change_cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.25,
                func = function()
                    v.card:flip()
                    play_sound('tarot2', 1, 0.6)
                    v.card:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end

        delay(0.25)

        if not context.blueprint then
            ArrowAPI.vhs.run_tape(card)
        end
    end
end

return consumInfo