local consumInfo = {
    name = 'Echoes ACT2',
    set = 'Stand',
    config = {
        evolve_key = 'c_jojobal_diamond_echoes_3',
        evolved = true,
        aura_colors = { 'adebbbDC' , '3bcc7bDC' },
        extra = {
            num_cards = 1,
            mult = 4,
            evolve_rounds = 0,
            evolve_num = 6,
            ref_suit = 'none',
        }
    },
    cost = 10,
    rarity = 'EvolvedRarity',
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'diamond',
        },
        custom_color = 'diamond'
    },
    blueprint_compat = true,
    artist = {'chvsau', 'Dolos'},
    programmer = 'Kekulism'
}

function consumInfo.loc_vars(self, info_queue, card)
    local suit_plural = ''
    local color = nil
    if G.GAME and G.GAME.wigsaw_suit then
        suit_plural = localize(G.GAME and G.GAME.wigsaw_suit, 'suits_plural')
        color = G.C.DARK_EDITION
    elseif card.ability.extra.ref_suit ~= 'none' then
        suit_plural = card.ability.extra.ref_suit == 'Wild' and 'a random suit' or localize(card.ability.extra.ref_suit, 'suits_plural')
        color = card.ability.extra.ref_suit == 'Wild' and G.C.EDITION or G.C.SUITS[card.ability.extra.ref_suit]
    end

    return {
        vars = {
            card.ability.extra.num_cards,
            card.ability.extra.mult,
            card.ability.extra.evolve_num - card.ability.extra.evolve_rounds,
            suit_plural,
            suit_plural == '' and "that card's suit" or '',
            card.ability.extra.ref_suit == 'Wild' and 'Any suit cards' or suit_plural,
            suit_plural == '' and 'That suit' or '',
            suit_plural == '' and 's' or '',
            colours = { color }
        }
    }
end

function consumInfo.in_pool(self, args)
    if G.GAME.used_jokers['c_jojobal_diamond_echoes_1']
    or G.GAME.used_jokers['c_jojobal_diamond_echoes_3'] then
        return false
    end

    return true
end

local get_first_non_matching = function(suit, hand)
    for i, v in ipairs(hand) do
        if not v:is_suit(suit) and not SMODS.has_no_suit(v) then
            return v
        end
    end
    return nil
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.before and not context.blueprint and not context.retrigger_joker then
        if to_big(G.GAME.current_round.hands_played) == to_big(0) and card.ability.extra.ref_suit == 'none' then
            if #context.full_hand == card.ability.extra.num_cards and not SMODS.has_no_suit(context.full_hand[1]) then
                local ref_card = context.full_hand[1]
                card.ability.extra.ref_suit = SMODS.has_any_suit(ref_card) and 'Wild' or ref_card.base.suit
                return {
                    func = function()
                        ArrowAPI.stands.flare_aura(card, 0.50)
                    end,
                    extra = {
                        message = localize('k_echoes_recorded'),
                        card = card,
                    }
                }
            end
        elseif card.ability.extra.ref_suit and card.ability.extra.ref_suit ~= "none" then
            local find_suit = (card.ability.extra.ref_suit == 'Wild') and pseudorandom_element(SMODS.Suits, pseudoseed('jojobal_echoes_wild')).key or card.ability.extra.ref_suit
            local nm = get_first_non_matching(G.GAME and G.GAME.wigsaw_suit or find_suit, context.scoring_hand)
            if not nm then return end

            ArrowAPI.stands.flare_aura(card, 0.50)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_boing'), colour = G.C.STAND})

            local percent = 1.15 - (1-0.999)/(#context.scoring_hand-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.15,
                func = function()
                    nm:flip();
                    play_sound('card1', percent);
                    nm:juice_up(0.3, 0.3);
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.45,
                func = function()
                    if card.ability.extra.ref_suit == 'Wild' then
                        nm:set_ability(G.P_CENTERS.m_wild)
                    end

                    nm:change_suit(G.GAME and G.GAME.wigsaw_suit or find_suit);
                    card:juice_up();
                    return true
                end
            }))

            local percent = 0.85 + (1-0.999)/(#context.scoring_hand-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.15,
                func = function()
                    nm:flip();
                    play_sound('tarot2', percent, 0.6);
                    nm:juice_up(0.3, 0.3);
                    return true
                end
            }))

            delay(0.5)
        end
    end

    if context.individual and context.cardarea == G.play and card.ability.extra.ref_suit ~= "none"
    and context.other_card:is_suit(G.GAME.wigsaw_suit or card.ability.extra.ref_suit) then
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.50)
            end,
            extra = {
                mult = card.ability.extra.mult,
                card = flare_card,
            }
        }
    end

    if context.end_of_round and context.main_eval and not context.blueprint and not context.retrigger_joker then
        card.ability.extra.ref_suit = 'none'
        card.ability.extra.evolve_rounds = card.ability.extra.evolve_rounds + 1
        if card.ability.extra.evolve_rounds >= card.ability.extra.evolve_num then
            check_for_unlock({ type = "evolve_echoes" })
            ArrowAPI.stands.evolve_stand(card)
        else
            return {
                no_retrigger = true,
                message = card.ability.extra.evolve_rounds..'/'..card.ability.extra.evolve_num,
                colour = G.C.STAND
            }
        end
    end
end


return consumInfo