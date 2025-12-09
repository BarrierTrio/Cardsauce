local consumInfo = {
    name = 'Made in Heaven',
    set = 'Stand',
    config = {
        aura_colors = { 'bd53f3DC', '491d96DC' },
        stand_mask = true,
        evolved = true,
        extra = {
            hand_mod = 1,
            discard_mod = 1
        }
    },
    cost = 10,
    rarity = 'EvolvedRarity',
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'stone',
        },
        custom_color = 'stone'
    },
    blueprint_compat = true,
    artist = 'MightyKingWario',
    programmer = 'Kekulism'
}

function consumInfo.in_pool(self, args)
    if G.GAME.used_jokers['c_jojobal_stone_white_moon']
    or G.GAME.used_jokers['c_jojobal_stone_white'] then
        return false
    end

    return true
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.before then
        ease_hands_played(card.ability.extra.hand_mod)
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.50)
            end,
            extra = {
                card = flare_card,
                message = localize{type = 'variable', key = 'a_hands', vars = {card.ability.extra.hand_mod}},
                colour = G.C.BLUE
            }
        }
    end

    if context.pre_discard then
        ease_discard(card.ability.extra.discard_mod)
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.50)
            end,
            extra = {
                card = flare_card,
                message = localize{type = 'variable', key = 'a_plus_discard', vars = {card.ability.extra.discard_mod}},
                colour = G.C.RED
            }
        }
    end
end


return consumInfo