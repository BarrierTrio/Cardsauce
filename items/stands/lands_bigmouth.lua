local consumInfo = {
    name = 'Bigmouth Strikes Again',
    set = 'Stand',
    config = {
        aura_colors = { 'f3e2b5DC', 'd2caa4DC' },
        extra = {
            hand_size = 5,
            suit_count = 4
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'lands',
        },
        custom_color = 'lands'
    },
    blueprint_compat = false,
    artist = 'gote',
}

function consumInfo.loc_vars(self, info_queue, card)
    return { 
        vars = {
            card.ability.extra.hand_size,
            card.ability.extra.suit_count,
            ArrowAPI.string.format_number(card.ability.extra.hand_size, 'order')
        }
    }
end

function consumInfo.calculate(self, card, context)
	if not context.before or #context.full_hand ~= card.ability.extra.hand_size or context.blueprint or context.retrigger_joker then return end

    -- record flip cards and do initial flip
    if not next(context.poker_hands['Flush']) then return end

    local target_key = nil
    for i, v in ipairs(context.poker_hands['Flush'][1]) do
        if not SMODS.has_any_suit(v) then
            target_key = v.base.suit
            break
        end
    end

    if not target_key then
        target_key = pseudorandom_element(SMODS.Suits, pseudoseed('jojobal_bigmouth_randomsuit')).key
    end

    local change_cards = {}
    for i, v in ipairs(context.full_hand) do
        -- find any cards not of the target transform key to transform
        if v.base.suit ~= target_key then
            local change = v
            change_cards[#change_cards+1] = change
            local suit = SMODS.Suits[target_key].card_key
            local rank = SMODS.Ranks[change.base.value].card_key
            change:set_base(G.P_CARDS[suit..'_'..rank], nil, true)

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    change:flip()
                    play_sound('card1')
                    change:juice_up(0.3, 0.3)
                    return true 
                end 
            }))
        end
    end

    if #change_cards < 1 then return end

    ArrowAPI.stands.flare_aura(card, 0.5)
    card_eval_status_text(card, 'extra', nil, nil, nil, {
        message = localize(target_key, 'suits_plural'),
        colour = G.C.SUITS[target_key]
    })

    for i=1, #change_cards do
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                change_cards[i]:set_sprites(nil, G.P_CARDS[change_cards[i].config.card_key])
                return true 
            end
        }))
    end
    
    -- do flip back over
    for i=1, #change_cards do
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.25,
            func = function() 
                change_cards[i]:flip()
                play_sound('tarot2', 1, 0.6)
                change_cards[i]:juice_up(0.3, 0.3)
                return true 
            end 
        }))
    end
end


return consumInfo