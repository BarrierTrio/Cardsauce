local consumInfo = {
    name = 'Dirty Deeds Done Dirt Cheap',
    set = 'csau_Stand',
    config = {
        aura_colors = { 'f3b7f5DC', 'c77ecfDC' },
        stand_mask = true,
        evolve_key = 'c_csau_steel_d4c_love',
        extra = {
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
        if SMODS.has_enhancement(v, 'm_lucky') then lucky = lucky+1 end
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
    if context.end_of_round and context.main_eval and not context.retrigger_joker and not context.blueprint then
        card.ability.extra.d4c_pair_this_round = nil
    end

    if card.debuff then return end

    if context.destroy_card and not context.retrigger_joker and not context.blueprint
    and context.scoring_name == "Pair" and not card.ability.extra.d4c_pair_this_round then
        card.ability.extra.d4c_pair_this_round = true
        context.destroy_card.csau_removed_by_d4c = true
        return {
            no_retrigger = true,
            remove = true
        }
    end

    if context.remove_playing_cards and not context.retrigger_joker and not context.blueprint then
        local valid_removes = 0
        for _, v in ipairs(context.removed) do
            if v.csau_removed_by_d4c then
                valid_removes = valid_removes + 1
            end
        end

        if valid_removes > 0 then
            G.FUNCS.csau_flare_stand_aura(card, 0.50)
            G.E_MANAGER:add_event(Event({
                func = (function()
                    card:juice_up()
                    play_sound('generic1')
                    return true
                end)
            }))
        end
    end
end

local ref_check_unlock = check_for_unlock
function check_for_unlock(args)
    local ret = ref_check_unlock(args)

    if args.type == 'modify_deck' then
        local d4cs = SMODS.find_card('c_csau_steel_d4c')
        local num_luckies = get_lucky()
        for _, v in ipairs(d4cs) do
            if to_big(num_luckies) >= to_big(v.ability.extra.evolve_num) then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        check_for_unlock({ type = "evolve_d4c" })
                        G.FUNCS.csau_evolve_stand(v)
                        return true
                    end
                }))
            end
        end
    end

    return ret
end

return consumInfo