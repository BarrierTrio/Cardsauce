local jokerInfo = {
    name = 'Plaguewalker',
    atlas = 'jokers',
	pos = {x = 0, y = 12},
    config = {
        extra = {
            glass_mult = 3,
            glass_break = 2,
        }
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'joel',
            'monkeywrench',
        },
        custom_color = 'monkeywrench'
    },
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'Zeurel'
}

local function apply_plague(x_mult, break_chance)
    if next(SMODS.find_card('j_csau_plaguewalker')) then return end

    for _, v in pairs(G.I.CARD) do
        if v.config and v.config.center and v.config.center.key == 'm_glass' then
            v.ability.extra = break_chance
            v.ability.Xmult = x_mult
        end
    end
end

function jokerInfo.loc_vars(self, info_queue, card)
    local num, dom = SMODS.get_probability_vars(card, 1, card.ability.extra.glass_break, 'glass')
    info_queue[#info_queue+1] = next(SMODS.find_card('j_csau_plaguewalker'))
    and {key = "csau_glass_alt", set = "Other", specific_vars = {card.ability.extra.glass_mult, num, dom, }} or G.P_CENTERS.m_glass
    return { vars = { card.ability.extra.glass_mult, num, dom } }
end

function jokerInfo.in_pool(self, args)
    if not G.playing_cards then return true end

    for _, v in ipairs(G.playing_cards) do
        if v.config.center.key == 'm_glass' then
            return true
        end
    end
end

function jokerInfo.add_to_deck(self, card, from_debuff)
    apply_plague(card.ability.extra.glass_mult, card.ability.extra.glass_break)
end

function jokerInfo.load(self, card, cardTable, other_card)
    apply_plague(cardTable.ability.extra.glass_mult, cardTable.ability.extra.glass_break)
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    apply_plague(G.P_CENTERS.m_glass.config.Xmult, G.P_CENTERS.m_glass.config.extra)
end

return jokerInfo