local consumInfo = {
    name = 'Echoes ACT1',
    set = 'Stand',
    config = {
        aura_colors = { 'DCFB8CDC', '5EEB2FDC' },
        evolve_key = 'c_jojobal_diamond_echoes_2',
        extra = {
            num_cards = 1,
            mult = 3,
            evolve_rounds = 0,
            evolve_num = 3,
            ref_suit = 'none'
        }

    },
    cost = 4,
    rarity = 'StandRarity',
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
    local suit = ''
    local color = nil
    if G.GAME and G.GAME.wigsaw_suit then
        suit = localize(G.GAME and G.GAME.wigsaw_suit, 'suits_singular')
        color = G.C.DARK_EDITION
    elseif card.ability.extra.ref_suit ~= 'none' then
        suit = card.ability.extra.ref_suit == 'wild' and 'any' or localize(card.ability.extra.ref_suit, 'suits_singular')
        color = G.C.SUITS[card.ability.extra.ref_suit]
    end

    return {
        vars = {
            card.ability.extra.num_cards,
            card.ability.extra.mult,
            card.ability.extra.evolve_num - card.ability.extra.evolve_rounds,
            suit,
            suit == '' and 'matching' or '',
            colours = { color }
        }
    }
end

function consumInfo.in_pool(self, args)
    if G.GAME.used_jokers['c_jojobal_diamond_echoes_2']
    or G.GAME.used_jokers['c_jojobal_diamond_echoes_3'] then
        return false
    end

    return true
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.before and not context.blueprint and not context.retrigger_joker and to_big(G.GAME.current_round.hands_played) == to_big(0)
    and #context.full_hand == card.ability.extra.num_cards and not SMODS.has_no_suit(context.full_hand[1]) then
        local ref_card = context.full_hand[1]
        card.ability.extra.ref_suit = SMODS.has_any_suit(ref_card) and "Wild" or ref_card.base.suit
        return {
            no_retrigger = true,
            func = function()
                ArrowAPI.stands.flare_aura(card, 0.50)
            end,
            extra = {
                message = localize('k_echoes_recorded'),
                card = card
            }
        }
    end

    if context.individual and context.cardarea == G.play and ((card.ability.extra.ref_suit == 'Wild' and
    SMODS.has_any_suit(context.other_card)) or (card.ability.extra.ref_suit ~= "none"
    and context.other_card:is_suit(G.GAME.wigsaw_suit or card.ability.extra.ref_suit))) then
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