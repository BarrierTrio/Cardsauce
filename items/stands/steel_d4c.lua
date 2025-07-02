local consumInfo = {
    name = 'Dirty Deeds Done Dirt Cheap',
    set = 'csau_Stand',
    config = {
        aura_colors = { 'f3b7f5DC', 'c77ecfDC' },
        stand_mask = true,
        evolve_key = 'c_csau_steel_d4c_love',
        extra = {
            hands_played = {},
            evolve_num = 9,
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    hasSoul = true,
    part = 'steel',
    blueprint_compat = false
}

local function get_lucky()
    if not G.playing_cards then return 0 end
    local lucky = 0
    for k, v in pairs(G.playing_cards) do
        if v.ability.effect == "Lucky Card" then lucky = lucky+1 end
    end
    return lucky
end

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_lucky
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } }
    return {vars = {card.ability.extra.evolve_num, get_lucky()}}
end

function consumInfo.in_pool(self, args)
    return (not G.GAME.used_jokers['c_csau_steel_d4c_love'])
end

function consumInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_d4c" })
end

function consumInfo.calculate(self, card, context)
    if context.before and not context.retrigger_joker and not context.blueprint then
        card.ability.extra.hands_played[context.scoring_name] = (card.ability.extra.hands_played[context.scoring_name] or 0) + 1
    end

    if context.destroying_card and not context.retrigger_joker and not context.blueprint then
        if context.scoring_name == "Pair" and card.ability.extra.hands_played[context.scoring_name] == 1 then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.FUNCS.csau_flare_stand_aura(card, 0.50)
                    card:juice_up()
                    return true
                end
            }))
            return true
        end
    end

    if context.end_of_round and not context.retrigger_joker and not context.blueprint and not context.individual then
        card.ability.extra.hands_played = {}
    end
end


function consumInfo.update(self, card)
    if card.area == nil or card.area.config.collection or card.area ~= G.consumeables then return end

    if card.ability.d4c_evolve_queued then return end

    if to_big(get_lucky()) >= to_big(card.ability.extra.evolve_num) then
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0, func = function()
			check_for_unlock({ type = "evolve_d4c" })
            card.ability.d4c_evolve_queued = true
            G.FUNCS.evolve_stand(card)
        return true end}))
    end
end

return consumInfo