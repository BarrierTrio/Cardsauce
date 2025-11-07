local consumInfo = {
    name = 'Marilyn Manson',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'efac55DC', 'df7f32DC' },
        extra = {
            conv_money = 1,
            conv_score = 0.005
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'stone',
        },
        custom_color = 'stone'
    },
    blueprint_compat = false,
    artist = 'gote',
}

function consumInfo.loc_vars(self, info_queue, card)
    return {vars = {card.ability.extra.conv_money, card.ability.extra.conv_score * 100}}
end

local debt_collection = function(card)
    local percentage_left = (G.GAME.blind.chips-G.GAME.chips) / G.GAME.blind.chips
    local debt = math.ceil(percentage_left / card.ability.extra.conv_score)*card.ability.extra.conv_money
    local recoverable = 0
    if to_big(G.GAME.dollars - debt) >= to_big(G.GAME.bankrupt_at) then
        return {
            saved = true,
            ease = -debt
        }
    else
        local sell = {}
        if #G.jokers.cards > 0 then
            local pool = {}
            for i, v in ipairs(G.jokers.cards) do
                table.insert(pool, v)
            end
            while #pool > 0 do
                local joker = pseudorandom_element(pool, pseudoseed('debtcollector_joker'))
                for i = #pool, 1, -1 do
                    if pool[i] == joker then
                        table.remove(pool, i)
                        break
                    end
                end
                recoverable = recoverable + joker.sell_cost
                if to_big((G.GAME.dollars + recoverable) - debt) >= to_big(G.GAME.bankrupt_at) then
                    table.insert(sell, joker)
                    local ease = debt
                    if to_big((G.GAME.dollars + recoverable) - debt) > to_big(0) then
                        ease = ease + (G.GAME.dollars + recoverable) - debt
                    end
                    return {
                        saved = true,
                        ease = -ease,
                        sell = sell
                    }
                else
                    table.insert(sell, joker)
                end
            end
        end

        if to_big((G.GAME.dollars + recoverable) - debt) < to_big(G.GAME.bankrupt_at) then
            if #G.playing_cards > 0 then
                local pool = {}
                for i, v in ipairs(G.playing_cards) do
                    table.insert(pool, v)
                end
                while #pool > 0 do
                    local card = pseudorandom_element(pool, pseudoseed('debtcollector_cards'))
                    for i = #pool, 1, -1 do
                        if pool[i] == card then
                            table.remove(pool, i)
                            break
                        end
                    end
                    recoverable = recoverable + card.sell_cost
                    if to_big((G.GAME.dollars + recoverable) - debt) >= to_big(G.GAME.bankrupt_at) then
                        table.insert(sell, card)
                        local ease = -debt
                        if to_big((G.GAME.dollars + recoverable) - debt) > to_big(0) then
                            ease = (G.GAME.dollars + recoverable) - debt
                        end
                        return {
                            saved = true,
                            ease = -ease,
                            sell = sell
                        }
                    else
                        table.insert(sell, card)
                    end
                end
            end
        end
        return {
            death = "*fucking kills you*"
        }
    end
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.end_of_round and not context.blueprint and context.game_over and not context.retrigger_joker then
        local collect = debt_collection(card)
        if collect.saved then
            if collect.sell then
                for i, v in ipairs(collect.sell) do
                    play_sound('coin2')
                    v:juice_up(0.3, 0.4)
                    v:start_dissolve({G.C.GOLD})
                end
            end
            
            ease_dollars(collect.ease)
            return {
                no_retrigger = true,
                func = function()
                    ArrowAPI.stands.flare_aura(card, 0.50)
                    card:juice_up()
                    play_sound('tarot1')
                end,
                saved = 'ph_saved_marilyn',
                colour = G.C.RED
            }
        end
    end
end


return consumInfo