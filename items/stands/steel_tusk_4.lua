SMODS.PokerHandPart {
    key = 'csau_fibonacci',
    prefix_config = false,
    func = function(hand) 
        return csau_get_fibonacci(hand) 
    end,
}

SMODS.PokerHand {
    key = 'csau_Fibonacci',
    prefix_config = false,
    evaluate = function(parts, hand)
        if not (next(SMODS.find_card('j_fnwk_plancks_jokestar'))
        or next(SMODS.find_card("c_csau_steel_tusk_4")))
        or not next(parts.csau_fibonacci) then 
            return {} 
        end
        return { hand }
    end,
    example = {
        {'S_A', true},
        {'D_8', true},
        {'D_5', true},
        {'C_3', true},
        {'S_2', true},
    },
    mult = 6,
    l_mult = 3,
    chips = 45,
    l_chips = 25,
    visible = false,
}

SMODS.PokerHand {
    key = 'csau_FlushFibonacci',
    prefix_config = false,
    evaluate = function(parts, hand)
        if not (next(SMODS.find_card('j_fnwk_plancks_jokestar'))
        or next(SMODS.find_card("c_csau_steel_tusk_4")))
        or not next(parts.csau_fibonacci) or not next(parts._flush) then 
            return {} 
        end
        return { SMODS.merge_lists(parts.csau_fibonacci, parts._flush) }
    end,
    example = {
        {'H_A', true},
        {'H_8', true},
        {'H_5', true},
        {'H_3', true},
        {'H_2', true},
    },
    mult = 15,
    l_mult = 4,
    chips = 150,
    l_chips = 45,
    visible = false,
}

local consumInfo = {
    name = 'Tusk ACT4',
    set = 'csau_Stand',
    config = {
        stand_mask = true,
        evolved = true,
        extra = {
            chips = 50,
            hand_mod = 1
        }
    },
    cost = 10,
    rarity = 'csau_EvolvedRarity',
    alerted = true,
    hasSoul = true,
    part = 'steel',
    in_progress = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit_2", set = "Other", vars = { G.csau_team.wario, G.csau_team.cauthen } }
    return {vars = {card.ability.extra.chips, card.ability.extra.hand_mod}}
end

function consumInfo.in_pool(self, args)
    if next(SMODS.find_card('j_showman')) then
        return true
    end

    if G.GAME.used_jokers['c_csau_steel_tusk_1']
    or G.GAME.used_jokers['c_csau_steel_tusk_2']
    or G.GAME.used_jokers['c_csau_steel_tusk_3'] then
        return false
    end
    
    return true
end

function consumInfo.add_to_deck(self, card)
    set_consumeable_usage(card)
    G.GAME.hands['csau_Fibonacci'].visible = true
    G.GAME.hands['csau_FlushFibonacci'].visible = true
end

function consumInfo.remove_from_deck(self, card, from_debuff)
    -- compatability with fanworks mod, this other card also enables fibonacci hands
    if next(SMODS.find_card('j_fnwk_plancks_jokestar')) or next(SMODS.find_card("c_csau_steel_tusk_4")) then
        return
    end

    G.GAME.hands['csau_Fibonacci'].visible = false
    G.GAME.hands['csau_FlushFibonacci'].visible = false
end

function consumInfo.calculate(self, card, context)
    if context.individual and context.cardarea == G.play and not card.debuff and not context.repetition then
        if context.other_card:get_id() == 2 or
        context.other_card:get_id() == 3 or
        context.other_card:get_id() == 5 or
        context.other_card:get_id() == 8 or
        context.other_card:get_id() == 14 then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
    if context.before and context.cardarea == G.play and not card.debuff then
        if next(context.poker_hands['csau_Fibonacci']) then
            ease_hands_played(card.ability.extra.hand_mod)
            return {
                card = card,
                message = localize('k_plus_hand'),
                colour = G.C.BLUE
            }
        end
    end
end

function consumInfo.can_use(self, card)
    return false
end

return consumInfo