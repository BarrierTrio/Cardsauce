local jokerInfo = {
    name = 'Gravity',
    config = {
        extra = {
            mult = 0,
            mult_mod = 4,
        }
    },
    rarity = 1,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    has_shiny = true,
    streamer = "otherjoel",
    part = 'diamond',
    artist = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult } }
end

function jokerInfo.calculate(self, card, context)
    if context.setting_blind and not card.debuff and not card.getting_sliced and not context.blueprint and G.FUNCS.csau_get_num_stands() > 0 then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
        return {
            card = card,
            message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}}
        }
    end
    if context.joker_main and context.cardarea == G.jokers and card.ability.extra.mult > 0 then
        return {
            mult = card.ability.extra.mult,
        }
    end
    if context.selling_card then
        if context.card.ability.set == "Stand" then
            card.ability.extra.mult = 0
            return {
                card = card,
                message = localize('k_reset')
            }
        end
    end
    if context.replace_stand then
        card.ability.extra.mult = 0
        return {
            card = card,
            message = localize('k_reset')
        }
    end
end

return jokerInfo