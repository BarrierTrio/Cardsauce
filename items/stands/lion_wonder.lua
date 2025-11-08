local consumInfo = {
    name = 'Wonder of U',
    set = 'Stand',
    config = {
        stand_mask = true,
        stand_shadow = 0,
        extra = {
            wonder_form = 1,
            x_mult = 1,
            x_mult_mod = 0.2,
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'lion',
        },
        custom_color = 'lion'
    },
    blueprint_compat = true,
    artist = {'Vivian Giacobbi', 'Stupisms'}
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_lucky
    return {
        vars = {card.ability.extra.x_mult_mod, card.ability.extra.x_mult},
        key = self.key..(card.ability.extra.wonder_form > 1 and '_'..card.ability.extra.wonder_form or '')
    }
end

SMODS.Atlas({ key = 'lion_wonder_2', path = "stands/lion_wonder_2.png", px = 71, py = 95 })
SMODS.Atlas({ key = 'lion_wonder_3', path = "stands/lion_wonder_3.png", px = 71, py = 95 })

function consumInfo.set_ability(self, card, initial, delay_sprites)
    if not card.config.center.discovered and (G.OVERLAY_MENU or G.STAGE == G.STAGES.MAIN_MENU) then
        return
    end

    if G.PROFILES[G.SETTINGS.profile].progress.highest_wonder then
        card.ability.extra.wonder_form = G.PROFILES[G.SETTINGS.profile].progress.highest_wonder

        if card.ability.extra.wonder_form > 1 then
            card.config.center.atlas = "jojobal_lion_wonder_"..card.ability.extra.wonder_form
        end

        card:set_sprites(card.config.center)
        card.config.center.atlas = 'jojobal_lion_wonder'

        if card.ability.extra.wonder_form == 2 then
            card.config.center.config.stand_shadow = nil
            card.config.center.config.aura_colors = { '28010126', '711B1A26' }
        elseif card.ability.extra.wonder_form == 3 then
            card.config.center.config.stand_shadow = nil
            card.config.center.config.aura_colors = { '280101DC', '711B1ADC' }
        end
    end
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.joker_main and card.ability.extra.x_mult > 1 then
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.50)
            end,
            extra = {
                x_mult = card.ability.extra.x_mult,
                card = flare_card
            }
        }
    end

    if context.destroy_card and not context.blueprint and not context.retrigger_joker then
        if SMODS.has_enhancement(context.destroy_card, 'm_lucky') and SMODS.in_scoring(context.destroy_card, context.scoring_hand) and not context.destroy_card.debuff then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_mod
            context.destroy_card.jojobal_removed_by_wonder = true
            return {
                no_retrigger = true,
                remove = true,
            }
        end
    end

    if context.post_playing_card_removed and context.removed.jojobal_removed_by_wonder and not context.blueprint then
        local update_sprite = false
        if to_big(card.ability.extra.x_mult) >= to_big(1.9) and card.ability.extra.wonder_form == 1 then
            card.config.center.config.stand_shadow = nil
            card.config.center.config.aura_colors = { '280101A0', '711B1AA0' }
            card.ability.extra.wonder_form = 2
            update_sprite = true
        elseif to_big(card.ability.extra.x_mult) >= to_big(3.9) and card.ability.extra.wonder_form == 2 then
            card.config.center.config.stand_shadow = nil
            card.config.center.config.aura_colors = { '280101DC', '711B1ADC' }
            card.ability.extra.wonder_form = 3
            update_sprite = true
        end

        return {
            func = function()
                ArrowAPI.stands.flare_aura(card, 0.50)
            end,
            extra = {
                message = localize('k_upgrade_ex'),
                colour = G.C.RED,
                card = card,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            if update_sprite then
                                if card.ability.extra.wonder_form > 1 then
                                    card.config.center.atlas = "jojobal_lion_wonder_"..card.ability.extra.wonder_form
                                end
                                card:set_sprites(card.config.center)
                                card.config.center.atlas = 'jojobal_lion_wonder'
                                card:juice_up()

                                G.PROFILES[G.SETTINGS.profile].progress.highest_wonder = card.ability.extra.wonder_form
                                G:save_settings()
                            end

                            context.removed:juice_up()
                            return true
                        end
                    }))
                    delay(0.4)
                end
            }
        }
    end
end

return consumInfo