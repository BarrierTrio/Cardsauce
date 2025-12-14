local jokerInfo = {
    name = 'Mug',
    atlas = 'jokers',
	pos = {x = 2, y = 12},
    config = {
        extra = {
            form = 'mug',
            mult = 1,
            mult_mod = 2,
            round_mod = 1,
            x_mult = 6,
            rounds = 5,
        }
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    pixel_size = { w = 71, h = 73 },
    pools = { ["Food"] = true },
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
    artist = 'SagaciousCejai'
}

local forms = {
    ["mug"] = {
        name = 'mug',
        pos = { x = 2, y = 12 },
        pixel_size = { w = 71, h = 73 },
    },
    ["moment"] = {
        name = 'moment',
        pos = { x = 4, y = 12},
        pixel_size = { w = 71, h = 95},
        soul_pos = { x = 5, y = 12},
    },
}

local change_form = function(card, form)
    if forms[form] then
        card.ability.extra.form = forms[form].name
        card.config.center.pos = forms[form].pos
        card.config.center.pixel_size = forms[form].pixel_size
        card.config.center.soul_pos = forms[form].soul_pos
    else
        for k, v in pairs(forms) do
            if v.name == form then
                card.ability.extra.form = v.name
                card.config.center.pos = v.pos
                card.config.center.pixel_size = v.pixel_size
                card.config.center.soul_pos = v.soul_pos
            end
        end
    end

    card.T.w = G.CARD_W
    card.T.h = G.CARD_H
    card:set_sprites(card.config.center)
    card.config.center.pos = forms.mug.pos
    card.config.center.pixel_size = forms.mug.pixel_size
    card.config.center.soul_pos = forms.mug.soul_pos

    return card.ability.extra.form
end

function jokerInfo.loc_vars(self, info_queue, card)
    return {
        vars = { card.ability.extra.mult, card.ability.extra.rounds, card.ability.extra.x_mult },
        key = "j_csau_mug_"..card.ability.extra.form
    }
end

function jokerInfo.set_sprites(self, card, _front)
    if card.config.center.discovered or card.bypass_discovery_center then
        card.children.center:reset()
    end
end

function jokerInfo.load(self, card, card_table, other_card)
    if card_table.ability.extra.form == 'moment' then
        change_form(card, 'moment')
    end
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main then
        return {
            mult = card.ability.extra.form == "mug" and card.ability.extra.mult or nil,
            x_mult = card.ability.extra.form == "moment" and card.ability.extra.x_mult or nil,
        }
    end

    if context.end_of_round and context.main_eval then
        if card.ability.extra.form == "moment" and SMODS.food_expires(card) then
            ArrowAPI.game.card_expire(card, 'k_mug_gone')
        elseif card.ability.extra.form == "mug" then

            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "mult",
                scalar_value = "mult_mod",
                operation = 'X',
                scaling_message = {
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                    colour = G.C.MULT
                }
            })

            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "rounds",
                scalar_value = "round_mod",
                operation = '-',
                no_message = true
            })

            if to_big(card.ability.extra.rounds) <= to_big(0) then
                check_for_unlock({ type = "activate_mug" })
                change_form(card, "moment")
                card:juice_up()
            end
        end
    end
end

return jokerInfo