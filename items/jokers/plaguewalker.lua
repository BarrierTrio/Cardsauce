local jokerInfo = {
    name = 'Plaguewalker',
    config = {
        extra = {
            glass_mult = 3,
            glass_break = 2,
            old_glass_mult = 2,
            old_glass_break = 4,
        }
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "joel",
    origin = 'monkeywrench'
}

local function apply_plague(card, x_mult, break_chance)
    local plagues = SMODS.find_card('j_csau_plaguewalker')
    local other_plague = false
    for _, v in ipairs(plagues) do
        if v ~= card and not v.debuff then
            other_plague = true
            break
        end
    end

    if other_plague then return end

    G.P_CENTERS.m_glass.config.Xmult = x_mult
    G.P_CENTERS.m_glass.config.extra = break_chance

    for _, v in pairs(G.I.CARD) do
        if v.config and v.config.center and v.config.center.key == 'm_glass' then
            v.ability.extra = break_chance
            v.ability.x_mult = x_mult
            v.ability.Xmult = x_mult
        end
    end
end

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_glass
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.zeurel } }
    return { vars = { card.ability.extra.glass_mult, SMODS.get_probability_vars(card, 1, card.ability.extra.glass_break) } }
end

function jokerInfo.in_pool(self, args)
    for _, v in ipairs(G.playing_cards) do
        if v.config.center.key == 'm_glass' then
            return true
        end
    end
end

function jokerInfo.add_to_deck(self, card, from_debuff)
    apply_plague(card, card.ability.extra.glass_mult, card.ability.extra.glass_break)
end

function jokerInfo.load(self, card, cardTable, other_card)
    apply_plague(card, card.ability.extra.glass_mult, card.ability.extra.glass_break)
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    apply_plague(card, card.ability.extra.old_glass_mult, card.ability.extra.old_glass_break)
end

return jokerInfo