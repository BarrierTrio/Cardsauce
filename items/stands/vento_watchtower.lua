local consumInfo = {
    name = 'All Along The Watchtower',
    set = 'csau_Stand',
    config = {
        aura_colors = { 'd4483eDC', '374649DC' },
        stand_mask = true,
        extra = {
            x_mult = 4,
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    hasSoul = true,
    part = 'feedback',
    blueprint_compat = true
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } }
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
        if not references.ranks[v.base.value] or not references.suits[v.base.suit] then
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
                G.FUNCS.csau_flare_stand_aura(flare_card, 0.50)
            end,
            extra = {
                xmult = card.ability.extra.x_mult,
                card = flare_card
            }
        }
    end
end

return consumInfo