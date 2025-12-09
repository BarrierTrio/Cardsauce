local consumInfo = {
    name = 'Smooth Operators',
    set = 'Stand',
    config = {
        aura_colors = { 'f2be53DC', 'f7e580DC' },
        extra = {
            rank_range = 1,
            rank_mod = 1,
            valid_this_score = {}
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'lands',
        },
        custom_color = 'lands'
    },
    blueprint_compat = false,
    artist = 'BarrierTrio/Gote',
}

function consumInfo.calculate(self, card, context)
    if context.after and not context.blueprint and not context.retrigger_joker then
        card.ability.extra.valid_this_score = {}
    end

    if not context.before or context.blueprint then return end

    local change_cards = {}
    if next(card.ability.extra.valid_this_score) and context.retrigger_joker then
        for valid_card, mod in pairs(card.ability.extra.valid_this_score) do
            SMODS.modify_rank(valid_card, mod, true)
            change_cards[#change_cards+1] = {card = valid_card, card_key = valid_card.config.card_key}
        end
    else
        local scoring_ranks = {}
        for _, scored in ipairs(context.scoring_hand) do
            scoring_ranks[scored:get_id()] = true
        end

        local ranges = {}
        for i=1, card.ability.extra.rank_range do
            ranges[#ranges+1] = i
            ranges[#ranges+1] = -i
        end

        for _, unscored in ipairs(context.full_hand) do
            if not SMODS.in_scoring(unscored, context.scoring_hand) then
                local in_range = nil
                for _, v in ipairs(ranges) do
                    local search_adjacent = unscored:get_id()+v
                    if search_adjacent < 2 then search_adjacent = 15 - search_adjacent end
                    if search_adjacent > 14 then search_adjacent = search_adjacent % 14 end

                    if scoring_ranks[search_adjacent] then
                        in_range = v
                        break
                    end
                end

                if in_range then
                    SMODS.modify_rank(unscored, in_range, true)
                    card.ability.extra.valid_this_score[unscored] = in_range
                    change_cards[#change_cards+1] = {card = unscored, card_key = unscored.config.card_key}
                end
            end
        end
    end

    if #change_cards < 1 then return end

    return {
        func = function()
            ArrowAPI.stands.flare_aura(card, 0.50)

            for _, v in ipairs(change_cards) do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        v.card:flip()
                        play_sound('card1')
                        v.card:juice_up(0.3, 0.3)
                        return true
                    end
                }))
            end

            for _, v in ipairs(change_cards) do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        v.card:set_sprites(nil, G.P_CARDS[v.card_key])
                        return true
                    end
                }))
            end

            -- do flip back over
            for _, v in ipairs(change_cards) do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.25,
                    func = function()
                        v.card:flip()
                        play_sound('tarot2', 1, 0.6)
                        v.card:juice_up(0.3, 0.3)
                        return true
                    end
                }))
            end
        end,
        message = localize('k_smooth_operators'),
        message_card = card
    }
end


return consumInfo