SMODS.PokerHandPart {
    key = 'jojobal_fibonacci',
    prefix_config = false,
    func = function(hand)
        return jojobal_get_fibonacci(hand)
    end,
}

SMODS.PokerHand {
    key = 'jojobal_Fibonacci',
    prefix_config = false,
    evaluate = function(parts, hand)
        if not next(parts.jojobal_fibonacci) then
            return {}
        end

        return { SMODS.is_poker_hand_visible('jojobal_Fibonacci') and hand or nil }
    end,
    example = {
        {'D_8', true},
        {'D_5', true},
        {'C_3', true},
        {'S_2', true},
        {'S_A', true},
    },
    mult = 6,
    l_mult = 3,
    chips = 45,
    l_chips = 25,
    visible = false,
}

SMODS.PokerHand {
    key = 'jojobal_FlushFibonacci',
    prefix_config = false,
    evaluate = function(parts, hand)
        if not next(parts.jojobal_fibonacci) or not next(parts._flush) then
            return {}
        end

        return { SMODS.is_poker_hand_visible('jojobal_Fibonacci')
        and SMODS.merge_lists(parts.jojobal_fibonacci, parts._flush) or nil }
    end,
    example = {
        {'H_8', true},
        {'H_5', true},
        {'H_3', true},
        {'H_2', true},
        {'H_A', true},
    },
    mult = 15,
    l_mult = 4,
    chips = 150,
    l_chips = 45,
    visible = false,
}

local consumInfo = {
    name = 'Tusk ACT4',
    set = 'Stand',
    config = {
        aura_colors = { 'ff7dbcDC', '55a3ffDC' },
        stand_mask = true,
        evolved = true,
        extra = {
            chips = 55,
            hand_mod = 1,
            valid_ids = {
                [2] = true,
                [3] = true,
                [5] = true,
                [8] = true,
                [14] = true,
            }
        }
    },
    cost = 10,
    rarity = 'EvolvedRarity',
    alerted = true,
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'steel',
        },
        custom_color = 'steel'
    },
    blueprint_compat = true,
    artist = {'MightyKingWario', 'Vivian Giacobbi'},
    programmer = 'Kekulism'
}

function consumInfo.loc_vars(self, info_queue, card)
    return {vars = {card.ability.extra.chips, card.ability.extra.hand_mod}}
end

function consumInfo.in_pool(self, args)
    if G.GAME.used_jokers['c_jojobal_steel_tusk_1']
    or G.GAME.used_jokers['c_jojobal_steel_tusk_2']
    or G.GAME.used_jokers['c_jojobal_steel_tusk_3'] then
        return false
    end

    return true
end

function consumInfo.add_to_deck(self, card)
    G.GAME.hands['jojobal_Fibonacci'].visible = true
    if G.GAME.hands.jojobal_FlushFibonacci.played > 0 then
        G.GAME.hands['jojobal_FlushFibonacci'].visible = true
    end
end

function consumInfo.remove_from_deck(self, card, from_debuff)
    -- compatability with fanworks mod, this other card also enables fibonacci hands
    if next(SMODS.find_card('j_fnwk_plancks_jokestar')) or next(SMODS.find_card("c_jojobal_steel_tusk_4")) then
        return
    end

    G.GAME.hands['jojobal_Fibonacci'].visible = false
    G.GAME.hands['jojobal_FlushFibonacci'].visible = false
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.individual and context.cardarea == G.play and card.ability.extra.valid_ids[context.other_card:get_id()] then
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.50)
            end,
            extra = {
                chips = card.ability.extra.chips,
                card = flare_card
            }
        }
    end

    if context.before and next(context.poker_hands['jojobal_Fibonacci']) then
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.50)
                ease_hands_played(card.ability.extra.hand_mod)
            end,
            extra = {
                card = flare_card,
                message = localize('k_plus_hand'),
                colour = G.C.BLUE
            }
        }
    end
end


return consumInfo