local jokerInfo = {
    name = "Stand of the Week",
    config = {
        extra = {
            x_mult_mod = 0.25
        },
    },
    rarity = 3,
    cost = 7,
    unlocked = false,
    unlock_condition = {type = 'discover_amount', num = 10 },
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    origin = 'jojo',
    dependencies = {
        config = {
            ['Stands'] = true,
        }
    },
    artist = 'BarrierTrio/Gote',
    programmer = 'Kekulism'
}

local function num_unique_stands()
    local unique_stands = 0

    if not G.consumeables then return unique_stands end

    for k, v in pairs(G.GAME.consumeable_usage) do
        if v.set == 'Stand' then
            unique_stands = unique_stands + 1
        end
    end

    return unique_stands
end

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.x_mult_mod, 1 + (card.ability.extra.x_mult_mod * num_unique_stands())} }
end

function jokerInfo.locked_loc_vars(self, info_queue, card)
    return { vars = { self.unlock_condition.num, G.DISCOVER_TALLIES.stands.tally } }
end

function jokerInfo.check_for_unlock(self, args)
    if args.type ~= self.unlock_condition.type then return end

    return G.DISCOVER_TALLIES.stands.tally >= self.unlock_condition.num
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main then
        local stands_obtained = num_unique_stands()
        if to_big(stands_obtained) > to_big(0) then
            return {
                x_mult = 1 + (card.ability.extra.x_mult_mod * stands_obtained),
            }
        end
    end
end

return jokerInfo


