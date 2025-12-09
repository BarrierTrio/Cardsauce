local consumInfo = {
    name = 'Tusk ACT1',
    set = 'Stand',
    config = {
        aura_colors = { 'ff7dbcDC', 'e675c2DC' },
        evolve_key = 'c_jojobal_steel_tusk_2',
        extra = {
            chips = 13,
            evolve_scores = 0,
            evolve_num = 20,
            evolved = false,
            valid_ids = {
                [2] = true,
                [14] = true,
            }
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    blueprint_compat = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'steel',
        },
        custom_color = 'steel'
    },
    artist = {'MightyKingWario', 'Vivian Giacobbi'},
    programmer = 'Kekulism'
}

function consumInfo.loc_vars(self, info_queue, card)
    return {vars = {card.ability.extra.chips, card.ability.extra.evolve_num - card.ability.extra.evolve_scores}}
end

function consumInfo.in_pool(self, args)
    if G.GAME.used_jokers['c_jojobal_steel_tusk_2']
    or G.GAME.used_jokers['c_jojobal_steel_tusk_3']
    or G.GAME.used_jokers['c_jojobal_steel_tusk_4'] then
        return false
    end

    return true
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.individual and context.cardarea == G.play and card.ability.extra.valid_ids[context.other_card:get_id()] then
        if not context.blueprint and not context.retrigger_joker then
            card.ability.extra.evolve_scores = card.ability.extra.evolve_scores + 1
        end

        local flare_card = context.blueprint_card or card
        return {
            func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.50)
            end,
            extra = {
                chips = card.ability.extra.chips,
                card = flare_card
            }
        }
    end

    if context.after and not context.blueprint and not context.retrigger_joker and not card.ability.extra.evolved then
        if to_big(card.ability.extra.evolve_scores) >= to_big(card.ability.extra.evolve_num) then
            card.ability.extra.evolved = true
            G.E_MANAGER:add_event(Event({
                func = (function()
                    ArrowAPI.stands.evolve_stand(card)
                    return true
                end)
            }))
        else
            return {
                no_retrigger = true,
                message = localize{type='variable',key='a_remaining',vars={card.ability.extra.evolve_num - card.ability.extra.evolve_scores}},
                colour = G.C.STAND
            }
        end
    end
end

return consumInfo