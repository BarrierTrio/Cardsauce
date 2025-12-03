local jokerInfo = {
    name = "Chips for Dinner",
    atlas = 'jokers',
	pos = {x = 6, y = 9},
    config = {
        extra = {
            chips = 80,
            chips_mod = 20,
        },
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    pools = { ["Food"] = true },
    has_shiny = true,
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'PaperMoon'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.chips, card.ability.extra.chips_mod } }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if card.ability.extra.chips > 0 and context.joker_main then
        return {
            chips = card.ability.extra.chips,
        }
    end

    if context.blueprint then return end

    if context.after and G.GAME.current_round.hands_left == 0 and SMODS.food_expires(context) then
        if (card.ability.extra.chips - card.ability.extra.chips_mod) <= 0 then
            ArrowAPI.game.card_expire(card)
        else
            card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chips_mod
            return {
                message = localize{type='variable',key='a_chips_minus',vars={card.ability.extra.chips_mod}},
                colour = G.C.CHIPS
            }
        end
    end

end

return jokerInfo