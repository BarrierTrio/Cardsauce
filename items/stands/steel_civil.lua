local function force_fool_card()
    if G.consumeables then
        return next(SMODS.find_card('c_jojobal_steel_civil')) and 'c_hanged_man' or nil
    end

    return nil
end

SMODS.Consumable:take_ownership('c_fool', {
    loc_vars = function(self, info_queue, card)
        local fool_c = G.GAME.last_tarot_planet and G.P_CENTERS[G.GAME.last_tarot_planet] or nil

        local force_card = force_fool_card()
        if force_card then fool_c = G.P_CENTERS[force_card] end

        -- imported cardsauce logic
        local last_tarot_planet = localize('k_none')
        if fool_c and fool_c.key == 'c_arrow_tarot_arrow' then
            last_tarot_planet = fool_c and localize{type = 'name_text', key = fool_c.key, set = fool_c.set, vars = { G.GAME.modifiers.max_stands or 1, (card.area.config.collection and localize('k_stand')) or (G.GAME.modifiers.max_stands > 1 and localize('b_stand_cards') or localize('k_stand')) }} or localize('k_none')
        else
            last_tarot_planet = fool_c and localize{type = 'name_text', key = fool_c.key, set = fool_c.set} or localize('k_none')
        end

        local colour = (not fool_c or fool_c.name == 'The Fool') and G.C.RED or G.C.GREEN
        local main_end = {
            {n=G.UIT.C, config={align = "bm", padding = 0.02}, nodes={
                {n=G.UIT.C, config={align = "m", colour = colour, r = 0.05, padding = 0.05}, nodes={
                    {n=G.UIT.T, config={text = ' '..last_tarot_planet..' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true}},
                }}
            }}
        }
        if not (not fool_c or fool_c.name == 'The Fool') then
            info_queue[#info_queue+1] = fool_c
        end

        return { vars = {last_tarot_planet}, main_end = main_end }
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            if G.consumeables.config.card_limit > #G.consumeables.cards then
                play_sound('timpani')

                local found_card = force_fool_card()
                if not found_card then
                    found_card = G.GAME.last_tarot_planet
                end
                local card = create_card('Tarot_Planet', G.consumeables, nil, nil, nil, nil, found_card, 'fool')
                card:add_to_deck()
                G.consumeables:emplace(card)
                card:juice_up(0.3, 0.5)
            end
            return true end }))
        delay(0.6)
    end,

    can_use = function(self, card)
        local force_card = force_fool_card()
        if force_card then return true end

        local has_space = #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
        return (has_space and G.GAME.last_tarot_planet and G.GAME.last_tarot_planet ~= 'c_fool')
    end
}, true)

SMODS.Consumable:take_ownership('c_emperor', {
    loc_vars = function (self, info_queue, card)
        local tarot_count = self.config.tarots
        local found_card = force_fool_card()
        if found_card then
            tarot_count = tarot_count - 1
            info_queue[#info_queue+1] = G.P_CENTERS[found_card]
        end
        tarot_count = math.max(0, tarot_count)

        return {
            vars = { tarot_count },
            key = self.key..(found_card and '_civil' or '')
        }
    end,

    use = function(self, card, area, copier)
        local tarot_count = self.config.tarots
        local found_card = force_fool_card()

        for i = 1, math.min(tarot_count, G.consumeables.config.card_limit - #G.consumeables.cards) do
            local force_key = i==1 and found_card
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
                        play_sound('timpani')
                        local new_tarot = create_card('Tarot', G.consumeables, nil, nil, nil, nil, force_key, 'emp')
                        new_tarot:add_to_deck()
                        G.consumeables:emplace(new_tarot)
                        card:juice_up(0.3, 0.5)
                    end
                    return true
                end
            }))
        end
        delay(0.6)
    end
}, true)

local consumInfo = {
    name = 'Civil War',
    set = 'Stand',
    config = {
        aura_colors = { 'c09f5fDC', '6c161fDC' },
        stand_mask = true,
        extra = {
            tarot = 'c_hanged_man'
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'steel',
        },
        custom_color = 'steel'
    },
    blueprint_compat = false,
    artist = 'BarrierTrio/Gote',
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.c_hanged_man
    return { vars = {localize{type = 'name_text', key = card.ability.extra.tarot, set = 'Tarot'}}}
end


function consumInfo.calculate(self, card, context)
    if card.debuff and not context.blueprint and not context.retrigger_joker then return end

    if context.using_consumeable and context.consumeable.config.center.key == 'c_hanged_man' then
        ArrowAPI.stands.flare_aura(card, 0.50)
    end
end

return consumInfo