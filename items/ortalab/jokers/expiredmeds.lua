local jokerInfo = {
    name = 'Expired',
    config = {
        extra = {
            chips = 50,
            chips_mod = 50,
            chance = 4,
        },
    },
    rarity = 2,
    cost = 2,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    origin = 'cardsauce',
    artist = 'MightyKingWario'
}

function jokerInfo.loc_vars(self, info_queue, card)
    local num, dom = SMODS.get_probability_vars(card, 1, card.ability.extra.chance, 'csau_expired_reset')
    return { vars = {card.ability.extra.chips_mod, num, dom, card.ability.extra.chips} }
end

function jokerInfo.add_to_deck(self, card, from_debuff)
    if from_debuff then return end

    if not card.ability.extra.csau_meds_id then
        G.GAME.csau_unique_meds_acquired = (G.GAME.csau_unique_meds_acquired or 0) + 1
        card.ability.extra.csau_meds_id = G.GAME.csau_unique_meds_acquired
        return
    end
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main and context.cardarea == G.jokers then
        return {
            chips = card.ability.extra.chips
        }
    end

    if context.selling_self and not next(SMODS.find_card('j_csau_expiredmeds')) then
        G.GAME.csau_sold_meds = {
            key = card.config.center.key,
            edition = card.edition and card.edition.type or nil
        }

        if SMODS.pseudorandom_probability(card, 'csau_expired_reset', 1, card.ability.extra.chance) then
            G.GAME.csau_unique_meds_acquired = 0
            return {
                message = localize('k_reset'),
                colour = G.C.IMPORTANT
            }
        end
    end

    if context.created_card and context.area == G.shop_jokers and G.GAME.csau_sold_meds then
        context.created_card:set_ability(G.P_CENTERS[G.GAME.csau_sold_meds.key], nil, nil)
        context.created_card.ability.extra.chips = context.created_card.ability.extra.chips + context.created_card.ability.extra.chips_mod * G.GAME.csau_unique_meds_acquired
        if G.GAME.csau_sold_meds.edition then
            context.created_card:set_edition({[G.GAME.csau_sold_meds.edition] = true}, true, true)
        end
    end
end

return jokerInfo
