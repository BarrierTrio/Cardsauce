SMODS.Sound({key = 'grand_1', path = 'grand_1.ogg'})
SMODS.Sound({key = 'grand_2', path = 'grand_2.ogg'})
SMODS.Sound({key = 'grand_3', path = 'grand_3.ogg'})
SMODS.Sound({key = 'grand_4', path = 'grand_4.ogg'})
SMODS.Sound({key = 'grand_5', path = 'grand_5.ogg'})
SMODS.Sound({key = 'grand_6', path = 'grand_6.ogg'})
SMODS.Sound({key = 'grand_7', path = 'grand_7.ogg'})

local jokerInfo = {
    name = "7 Funny Story",
    atlas = 'jokers',
	pos = {x = 4, y = 7},
    config = {
        extra = {
            remaining = 7,
            remain_mod = 1,
            card_id = 7,
            x_mult = 7,
        }
    },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pools = {
        ["Meme"] = true
    },
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'joel',
        },
        custom_color = 'joel'
    },
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'Akai (Balatrostuck)'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.remaining, card.ability.extra.x_mult, card.ability.extra.card_id} }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.individual and context.cardarea == G.play and card.ability.extra.remaining > 0
    and not context.other_card.debuff and context.other_card:get_id() == card.ability.extra.card_id then
        SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = "remaining",
            scalar_value = "remain_mod",
            operation = '-',
            no_message = true
        })

        local idx = math.floor(7 - card.ability.extra.remaining)
        return {
            x_mult = card.ability.extra.x_mult,
            remove_default_message = true,
            message = localize('k_grand_'..idx),
            sound = 'csau_grand_'..idx,
            per = 1,
            manual_percent = 1,
            colour = G.C['GRAND_'..math.random(1, 3)],
            func = function()
                if card.ability.extra.remaining <= 0 then
                    ArrowAPI.game.card_expire(card, 'k_grand_expire', G.C['GRAND_'..math.random(1, 3)])
                end
            end
        }
    end
end

return jokerInfo