local consumInfo = {
    name = 'The Hand',
    set = 'csau_Stand',
    config = {
        aura_colors = { '1d94e0DC', '4bc6e7DC' },
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    hasSoul = true,
    part = 'diamond',
    blueprint_compat = false,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.wario } }
end

local function is_removed(card, removed)
    for i, v in ipairs(removed) do
        if card == v then
            return true
        end
    end
    return false
end

function consumInfo.calculate(self, card, context)
    local bad_context = context.repetition or context.blueprint or context.individual or context.retrigger_joker
    if context.remove_playing_cards and not bad_context then
        local juice = false
        for i, card in ipairs(context.removed) do
            local pos = card.rank
            local cards_to_convert = {}
            for i=1, 2 do
                local mod = -1
                if i == 2 then mod = 1 end
                if card.area.cards[card.rank+mod] and not is_removed(card.area.cards[card.rank+mod], context.removed) then
                    cards_to_convert[#cards_to_convert+1] = card.area.cards[card.rank+mod]
                end
            end
            if #cards_to_convert > 0 then
                for i, v in ipairs(cards_to_convert) do
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:set_ability(card.config.center)
                            v:set_base(card.config.card)
                            v:juice_up()
                            return true
                        end
                    }))
                    juice = true
                end
            end
        end
        if juice then
            return {
                func = function()
                    card:juice_up()
                    G.FUNCS.csau_flare_stand_aura(card, 0.50)
                end,
                card = card,
                message = localize('k_thehand'),
                colour = G.C.STAND
            }
        end
    end
end


return consumInfo