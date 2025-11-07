local consumInfo = {
    name = 'All Along The Watchtower',
    set = 'Stand',
    config = {
        aura_colors = { 'd4483eDC', '374649DC' },
        stand_mask = true,
        extra = {
            x_mult = 4,
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    alerted = true,
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'feedback',
        },
        custom_color = 'feedback'
    },
    blueprint_compat = true,
    artist = 'gote',
}

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult } }
end

local references = {
    ranks = { 
        ['2'] = true,
        ['3'] = true,
        ['4'] = true,
        ['5'] = true,
        ['6'] = true,
        ['7'] = true,
        ['8'] = true,
        ['9'] = true,
        ['10'] = true,
        ['Jack'] = true,
        ['Queen'] = true,
        ['King'] = true,
        ['Ace'] = true
    },
    suits = { 
        ['Hearts'] = true,
        ['Spades'] = true,
        ['Diamonds'] = true,
        ['Clubs'] = true,
    }
}

local function has_standard_deck()
    if not G.playing_cards then
        return false
    end

    if #G.playing_cards ~= 52 then
        return false
    end

    local deck_table = {}
    for k, v in pairs(G.playing_cards) do
        if SMODS.has_no_rank(v) or not references.ranks[v.base.value] or SMODS.has_no_suit(v) or not references.suits[v.base.suit] then
            return false
        end

        if deck_table[v.config.card_key] then return false end
        
        deck_table[v.config.card_key] = true
    end

    return true
end

function consumInfo.calculate(self, card, context)
    if context.joker_main and has_standard_deck() then
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.50)
            end,
            extra = {
                xmult = card.ability.extra.x_mult,
                card = flare_card
            }
        }
    end
end

return consumInfo