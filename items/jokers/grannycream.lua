local jokerInfo = {
    name = 'Granny Cream',
    animation = {
        frames = 36,
        fps = 10,
    },
    config = {
        extra = {
            chip_goal = 150,
            chip_pool = 500,
        }
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    pools = { ["Food"] = true },
    origin = 'cardsauce',
    artist = 'Crisppyboat'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.chip_goal, card.ability.extra.chip_pool } }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff or context.blueprint then return end

    if context.joker_main and hand_chips < card.ability.extra.chip_goal and SMODS.food_expires(card) then
        local spent_chips = math.min(card.ability.extra.chip_pool, card.ability.extra.chip_goal - hand_chips)
        card.ability.extra.chip_pool = card.ability.extra.chip_pool - spent_chips

        return {
            chips = spent_chips
        }
    end

    if context.after and card.ability.extra.chip_pool <= 0 then
        ArrowAPI.game.card_expire(card, 'k_sipped_ex', G.C.CHIPS)
    end
end

return jokerInfo