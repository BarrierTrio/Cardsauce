local consumInfo = {
    name = 'Tusk ACT2',
    set = 'Stand',
    config = {
        aura_colors = { 'ff7dbcDC', '81476fDC' },
        evolved = true,
        evolve_key = 'c_jojobal_steel_tusk_3',
        extra = {
            chips = 21,
            evolve_destroys = 0,
            evolve_num = 3,
            evolved = false,
            valid_ids = {
                [2] = true,
                [3] = true,
                [14] = true,
            }
        }
    },
    cost = 10,
    rarity = 'EvolvedRarity',
    alerted = true,
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'steel',
        },
        custom_color = 'steel'
    },
    blueprint_compat = true,
    artist = {'MightyKingWario', 'Vivian Giacobbi'},
    programmer = 'Kekulism'
}

function consumInfo.loc_vars(self, info_queue, card)
    return {vars = {card.ability.extra.chips, card.ability.extra.evolve_num - card.ability.extra.evolve_destroys}}
end

function consumInfo.in_pool(self, args)
    if G.GAME.used_jokers['c_jojobal_steel_tusk_1']
    or G.GAME.used_jokers['c_jojobal_steel_tusk_3']
    or G.GAME.used_jokers['c_jojobal_steel_tusk_4'] then
        return false
    end

    return true
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.individual and context.cardarea == G.play and card.ability.extra.valid_ids[context.other_card:get_id()] then
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

    if context.remove_playing_cards and not context.blueprint and not context.retrigger_joker then
        card.ability.extra.evolve_destroys = card.ability.extra.evolve_destroys + #context.removed
        if to_big(card.ability.extra.evolve_destroys) >= to_big(card.ability.extra.evolve_num) and not card.ability.extra.evolved then
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
                message = card.ability.extra.evolve_destroys..'/'..card.ability.extra.evolve_num,
                colour = G.C.STAND
            }
        end
    end
end


return consumInfo