local consumInfo = {
    name = 'The Hand',
    set = 'Stand',
    config = {
        aura_colors = { '1d94e0DC', '4bc6e7DC' },
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'diamond',
        },
        custom_color = 'diamond'
    },
    blueprint_compat = false,
}

local function is_removed(card, removed)
    for i, v in ipairs(removed) do
        if card == v then
            return true
        end
    end
    return false
end

function consumInfo.calculate(self, card, context)
    if context.remove_playing_cards and not context.blueprint and not context.retrigger_joker then
        local juice = false
        for i, removed in ipairs(context.removed) do
            local cards_to_convert = {}
            for i=1, 2 do
                local mod = -1
                if i == 2 then mod = 1 end
                if removed.area.cards[removed.rank+mod] and not is_removed(removed.area.cards[removed.rank+mod], context.removed) then
                    cards_to_convert[#cards_to_convert+1] = removed.area.cards[removed.rank+mod]
                end
            end
            if #cards_to_convert > 0 then
                for _, v in ipairs(cards_to_convert) do
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            v:set_ability(removed.config.center)
                            v:set_base(removed.config.card)
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
                no_retrigger = true,
                func = function()
                    card:juice_up()
                    ArrowAPI.stands.flare_aura(card, 0.50)
                end,
                card = card,
                message = localize('k_thehand'),
                colour = G.C.STAND
            }
        end
    end
end


return consumInfo