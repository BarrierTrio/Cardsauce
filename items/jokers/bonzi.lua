local jokerInfo = {
    name = "Bonzi Buddy",
    animation = {
        frames = 12,
        fps = 10,
    },
    config = {
        extra = {
            mult = 0,
            mult_mod = 5,
            dollars = 5,
        },
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    display_size = { w = 87, h = 95 },
    pools = {
        ["Meme"] = true
    },
    width = 87,
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'Crisppyboat'
}

local function getSignum(num)
    if num >= 0 then return "+" else return "" end
end

function jokerInfo.set_sprites(self, card, _front)
    if card.config.center.discovered or card.bypass_discovery_center then
        card.children.center:set_role({
            role_type = 'Minor', --Major dictates movement, Minor is welded to some major
            offset = {x = -0.25, y = 0}, --Offset from Minor to Major
            major = card,
            draw_major = card,
            xy_bond = 'Strong',
            wh_bond = 'Strong',
            r_bond = 'Strong',
            scale_bond = 'Strong'
        })
    end
end

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.mult_mod, card.ability.extra.dollars, getSignum(card.ability.extra.mult)..card.ability.extra.mult} }
end

function jokerInfo.calculate(self, card, context)
    if context.setting_blind and not card.getting_sliced and not card.debuff and not context.blueprint then
        if to_big(G.GAME.dollars - card.ability.extra.dollars) >= to_big(next(SMODS.find_card('j_credit_card')) and -20 or 0) then
            if to_big(card.ability.extra.mult) < to_big(0) then
                card.ability.extra.mult = -card.ability.extra.mult
            end
            ease_dollars(-card.ability.extra.dollars)
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "mult",
                scalar_value = "mult_mod",
                scaling_message = {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MULT
                }
            })
        else
            if to_big(card.ability.extra.mult) > to_big(0) then
                local scale_table = {mult_mod = card.ability.extra.mult}
                card.ability.extra.mult = 0

                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_table = scale_table,
                    scalar_value = "mult_mod",
                    operation = '-',
                    scaling_message = {
                        message = localize('k_negative_mult'),
                        colour = G.C.DARK_EDITION
                    }
                })
            end
        end
    end

    if to_big(card.ability.extra.mult) ~= to_big(0) and context.joker_main then
        return {
            mult = card.ability.extra.mult,
        }
    end
end

function jokerInfo.update(self, card, dt)
    if not (card.area and card.area == G.pack_cards) then
        if card.children.buy_button and not card.children.buy_button.bonzi_draw then
            card.children.buy_button:set_alignment({offset = {x=-0,y=-0.3}})
            card.children.buy_button.bonzi_draw = true
        end

        if card.children.buy_and_use_button and not card.children.buy_and_use_button.bonzi_draw then
            card.children.buy_and_use_button:set_alignment({offset = {x=-0.7,y=0}})
            card.children.buy_and_use_button.bonzi_draw = true
        end

        if card.children.use_button and not card.children.use_button.bonzi_draw then
            card.children.use_button:set_alignment({offset = {x=-0.7,y=0}})
            card.children.use_button.bonzi_draw = true
        end
    end
end

return jokerInfo