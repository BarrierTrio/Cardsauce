local consumInfo = {
    name = 'Wonder of U',
    set = 'csau_Stand',
    config = {
        aura_colors = { '280101DC', '711b1aDC' },
        stand_mask = true,
        extra = {
            form = 'lion_wonder',
            xmult = 1,
            xmult_mod = 0.2,
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    hasSoul = true,
    part = 'lion',
    blueprint_compat = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_lucky
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.cauthen } }
    return {vars = {card.ability.extra.xmult_mod, card.ability.extra.xmult}}
end

local forms = {
    [1] = "lion_wonder",
    [2] = "lion_wonder_2",
    [3] = "lion_wonder_3",
}

for i = 1, #forms do
    if i ~= 1 then
        SMODS.Atlas({ key = forms[i], path ="stands/"..forms[i]..".png", px = 71, py = 95 })
    end
end

local function updateSprite(card)
    if card.ability.extra.form then
        if card.config.center.atlas ~= card.ability.extra.form then
            local old_atlas = card.config.center.atlas
            card.config.center.atlas = "csau_"..card.ability.extra.form
            card:set_sprites(card.config.center)
            card.config.center.atlas = old_atlas
            if G.SETTINGS.highest_wonderofu ~= forms[3] then
                G.SETTINGS.highest_wonderofu = card.ability.extra.form
                G:save_settings()
            end
        end
    end
end

function consumInfo.set_sprites(self, card, _front)
    if card.config.center.discovered or card.bypass_discovery_center then
        card.children.center:reset()
    end
end

function consumInfo.calculate(self, card, context)
    if context.joker_main then
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                G.FUNCS.csau_flare_stand_aura(flare_card, 0.50)
            end,
            extra = {
                xmult = card.ability.extra.xmult,
                card = flare_card
            }
        }
    end
        
    if context.destroy_card and not context.blueprint and not context.retrigger_joker and not card.debuff then
        if SMODS.has_enhancement(context.destroy_card, 'm_lucky') and SMODS.in_scoring(context.destroy_card, context.scoring_hand) and not context.destroy_card.debuff then
            context.destroy_card.csau_removed_by_wonder = true
            return {
                remove = true,
            }
        end
    end

    if context.csau_card_destroyed and context.removed.csau_removed_by_wonder and not context.blueprint and not context.retrigger_joker then
        card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod

        local update_sprite = false
        if to_big(card.ability.extra.xmult) >= to_big(1.9) and card.ability.extra.form == 'lion_wonder' then
            card.ability.extra.form = 'lion_wonder_2'
            update_sprite = true
        elseif to_big(card.ability.extra.xmult) >= to_big(3) and card.ability.extra.form == 'lion_wonder_2' then
            card.ability.extra.form = 'lion_wonder_3'
            update_sprite = true
        end

        if update_sprite then
            G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
            updateSprite(card)
            card:juice_up()
            return true end }))
        end

        return {
            func = function()
                G.FUNCS.csau_flare_stand_aura(card, 0.50)
            end,
            message = localize('k_upgrade_ex'),
            colour = G.C.RED,
            card = card
        }
    end
end


function consumInfo.update(self, card)
    if card.area.config.collection and G.SETTINGS.highest_wonderofu and card.ability.extra.form ~= G.SETTINGS.highest_wonderofu then
        card.ability.extra.form = G.SETTINGS.highest_wonderofu
        updateSprite(card)
    elseif G.screenwipe then
        updateSprite(card)
    end
end

return consumInfo