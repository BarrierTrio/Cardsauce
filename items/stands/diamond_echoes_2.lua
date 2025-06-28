local consumInfo = {
    name = 'Echoes ACT2',
    set = 'csau_Stand',
    config = {   
        evolve_key = 'c_csau_diamond_echoes_3',
        evolved = true,
        aura_colors = { 'adebbbDC' , '3bcc7bDC' },
        extra = {
            num_cards = 1,
            mult = 4,
            evolve_rounds = 0,
            evolve_num = 6,
        }
    },
    cost = 10,
    rarity = 'csau_EvolvedRarity',
    alerted = true,
    hasSoul = true,
    part = 'diamond',
    in_progress = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit_2", set = "Other", vars = { G.csau_team.chvsau, G.csau_team.dolos } }
    local color = G.C.IMPORTANT
    if G.GAME and G.GAME.wigsaw_suit then
        color = G.C.SUITS[G.GAME and G.GAME.wigsaw_suit]
    elseif card.ability.extra.ref_suit then
        if card.ability.extra.ref_suit == 'wild' then
            color = G.C.DARK_EDITION
        else
            color = G.C.SUITS[card.ability.extra.ref_suit]
        end
    end
    local suit = localize('k_none')
    if G.GAME and G.GAME.wigsaw_suit then
        suit = localize(G.GAME and G.GAME.wigsaw_suit, 'suits_plural')
    elseif card.ability.extra.ref_suit then
        if card.ability.extra.ref_suit == 'wild' then
            suit = G.localization.descriptions.Enhanced.m_wild.name
        else
            suit = localize(card.ability.extra.ref_suit, 'suits_plural')
        end
    end
    return {vars = {card.ability.extra.num_cards, card.ability.extra.mult, card.ability.extra.evolve_num - card.ability.extra.evolve_rounds, suit, colours = { color } } }
end

function consumInfo.in_pool(self, args)
    if next(SMODS.find_card('j_showman')) then
        return true
    end

    if G.GAME.used_jokers['c_csau_diamond_echoes_1']
    or G.GAME.used_jokers['c_csau_diamond_echoes_3'] then
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
    local bad_context = context.repetition or context.blueprint or context.individual or context.retrigger_joker
    if context.before and not card.debuff and not bad_context then
        if to_big(G.GAME.current_round.hands_played) == to_big(0) then
            if #context.full_hand == card.ability.extra.num_cards then
                local ref_card = context.full_hand[1]
                if SMODS.has_any_suit(ref_card) then
                    card.ability.extra.ref_suit = "wild"
                    return {
                        message = localize('k_echoes_recorded'),
                        card = card
                    }
                elseif not SMODS.has_no_suit(ref_card) then
                    card.ability.extra.ref_suit = ref_card.base.suit
                    return {
                        message = localize('k_echoes_recorded'),
                        card = card,
                        extra = {
                            delay = 0.5
                        }
                    }
                end
            end
        elseif card.ability.extra.ref_suit and card.ability.extra.ref_suit ~= "wild" and not card.ability.extra.nm then
            local nm = get_first_non_matching(G.GAME and G.GAME.wigsaw_suit or card.ability.extra.ref_suit, context.scoring_hand)
            if nm then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_boing'), colour = G.C.STAND})
                local percent = 1.15 - (1-0.999)/(#context.scoring_hand-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'before',delay = 0.15,func = function() nm:flip();play_sound('card1', percent);nm:juice_up(0.3, 0.3);return true end }))
                G.E_MANAGER:add_event(Event({trigger = 'before',delay = 1,func = function() nm:change_suit(G.GAME and G.GAME.wigsaw_suit or card.ability.extra.ref_suit);card:juice_up();return true end }))
                local percent = 0.85 + (1-0.999)/(#context.scoring_hand-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'before',delay = 0.15,func = function() nm:flip();play_sound('tarot2', percent, 0.6);nm:juice_up(0.3, 0.3);return true end }))
                delay(0.5)
                card.ability.extra.nm = true
            end
        end
    end
    if context.individual and context.cardarea == G.play and not card.debuff then
        if to_big(G.GAME.current_round.hands_played) > to_big(0) and card.ability.extra.ref_suit then
            if card.ability.extra.ref_suit == "wild" or context.other_card:is_suit(G.GAME and G.GAME.wigsaw_suit or card.ability.extra.ref_suit) then
                return {
                    mult = card.ability.extra.mult,
                    card = card
                }
            end
        end
    end
    if context.end_of_round and not bad_context then
        card.ability.extra.ref_suit = nil
        card.ability.extra.nm = false
        card.ability.extra.evolve_rounds = card.ability.extra.evolve_rounds + 1
        if card.ability.extra.evolve_rounds >= card.ability.extra.evolve_num then
            check_for_unlock({ type = "evolve_echoes" })
            G.FUNCS.csau_evolve_stand(card)
        else
            return {
                message = card.ability.extra.evolve_rounds..'/'..card.ability.extra.evolve_num,
                colour = G.C.STAND
            }
        end
    end
end


return consumInfo