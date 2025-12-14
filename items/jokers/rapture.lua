local jokerInfo = {
    name = 'Rapture',
    atlas = 'jokers',
	pos = {x = 7, y = 8},
    config = {
        extra = {
            mult = 0,
            mult_mod = 1
        }
    },
    rarity = 1,
    cost = 6,
    unlocked = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    unlock_condition = {type = 'win_no_hand', extra = 'High Card'},
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'vinny',
        },
        custom_color = 'vinny'
    },
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'Burdrehnar'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult }}
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.before and context.scoring_name == "High Card" then
        if card.ability.extra.mult > 0 then
            card.ability.extra.mult = 0
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        else
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "mult",
                scalar_value = "mult_mod",
                message_key = 'a_mult',
                message_colour = G.C.MULT
            })
            if to_big(card.ability.extra.mult) >= to_big(30) and next(SMODS.find_card('j_csau_kings')) then
                check_for_unlock({ type = "supreme_ascend" })
            end
        end
    end

    if context.joker_main and card.ability.extra.mult > 0 then
        return {
            mult = card.ability.extra.mult,
        }
    end
end

return jokerInfo
