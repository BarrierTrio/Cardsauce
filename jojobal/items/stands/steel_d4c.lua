local consumInfo = {
    name = 'Dirty Deeds Done Dirt Cheap',
    set = 'Stand',
    config = {
        aura_colors = { 'f3b7f5DC', 'c77ecfDC' },
        stand_mask = true,
        evolve_key = 'c_jojobal_steel_d4c_love',
        extra = {
            evolve_num = 9,
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
        category = 'jojo',
        sub_origins = {
            'steel',
        },
        custom_color = 'steel'
    },
    blueprint_compat = false,
    artist = 'BarrierTrio/Gote',
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = G.P_CENTERS.m_lucky
    return {vars = {card.ability.extra.evolve_num, ArrowAPI.game.get_enhanced_tally('m_lucky')}}
end

function consumInfo.in_pool(self, args)
    return (not G.GAME.used_jokers['c_jojobal_steel_d4c_love'])
end

function consumInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_d4c" })
end

function consumInfo.calculate(self, card, context)
    if context.retrigger_joker or context.blueprint then return end

    if context.after and context.scoring_name == 'Pair' then
        card.ability.extra.d4c_pair_this_round = true
    end

    if context.end_of_round and context.main_eval then
        card.ability.extra.d4c_pair_this_round = nil
    end

    if card.debuff then return end

    if context.destroy_card and context.scoring_name == "Pair"
    and SMODS.in_scoring(context.destroy_card, context.scoring_hand)
    and not card.ability.extra.d4c_pair_this_round then
        context.destroy_card.jojobal_removed_by_d4c = true
        return {
            no_retrigger = true,
            remove = true
        }
    end

    if context.remove_playing_cards then
        local valid_removes = 0
        for _, v in ipairs(context.removed) do
            if v.jojobal_removed_by_d4c then
                valid_removes = valid_removes + 1
            end
        end

        if valid_removes > 0 then
            ArrowAPI.stands.flare_aura(card, 0.50)
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
        local d4cs = SMODS.find_card('c_jojobal_steel_d4c')
        local num_luckies = ArrowAPI.game.get_enhanced_tally('m_lucky')
        for _, v in ipairs(d4cs) do
            if to_big(num_luckies) >= to_big(v.ability.extra.evolve_num) then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        check_for_unlock({ type = "evolve_d4c" })
                        ArrowAPI.stands.evolve_stand(v)
                        return true
                    end
                }))
            end
        end
    end

    return ret
end

return consumInfo