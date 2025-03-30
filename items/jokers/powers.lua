local jokerInfo = {
    name = 'Live Dangerously',
    config = {
        extra = 2
    },
    rarity = 1,
    cost = 6,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "joel",
}

G.FUNCS.powers_active = function(card)
    card = card or nil
    local powers = SMODS.find_card("j_csau_powers")
    for i, v in ipairs(powers) do
        if (card and v ~= card) or not card then
            if not v.debuff then
                return true
            end
        end
    end
    return false
end

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
    return { vars = { card.ability.extra } }
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main and context.cardarea == G.jokers then
        return {
            xmult = card.ability.extra,
        }
    end
end

local function activate(bool)
    if bool then
        G.GAME.probabilities.csau_backup = G.GAME.probabilities.normal
        G.GAME.probabilities.normal = 0
    else
        G.GAME.probabilities.normal = G.GAME.probabilities.csau_backup
    end
end

function jokerInfo.add_to_deck(self, card)
    activate(true)
end

function jokerInfo.remove_from_deck(self, card)
    activate(false)
end

function jokerInfo.update(self, card)
    if card.debuff and not card.ability.debuff then
        card.ability.debuff = true
        if not G.FUNCS.powers_active(card) then
            activate(false)
        end
    elseif not card.debuff and card.ability.debuff then
        card.ability.debuff = false
        activate(true)
    end
end

return jokerInfo