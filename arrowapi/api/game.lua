local ref_level_up = level_up_hand
function level_up_hand(card, hand, instant, amount)
    amount = amount or 1
    local eff = {}
    SMODS.calculate_context({modify_level_increment = true, card = card, hand = hand, amount = amount}, eff)
    SMODS.trigger_effects(eff)
    for i, v in ipairs(eff) do
        if v.jokers then
            if v.jokers.mult_inc then
                amount = amount * v.jokers.mult_inc
            end
        end
    end

    local ret = ref_level_up(card, hand, instant, amount)
    if not ArrowAPI.bypass_level_up_context then
        G.GAME.arrow_last_upgraded_hand = {[hand] = true}
        SMODS.calculate_context({hand_upgraded = true, upgraded = {[hand] = true}, amount = amount})
    end

    return ret
end

function level_up_hand_bypass(card, hand, instant, amount, bypass_context)
    ArrowAPI.bypass_level_up_context = bypass_context
    local ret = level_up_hand(card, hand, instant, amount)

    if ArrowAPI.bypass_level_up_context then
        G.GAME.arrow_last_upgraded_hand = {[hand] = true}
        SMODS.calculate_context({hand_upgraded = true, upgraded = {[hand] = true}, amount = amount})
        ArrowAPI.bypass_level_up_context = nil
    end

    return ret
end

local function game_over_handler(win)
    if win then
        win_game()
        G.GAME.won = true
    else
        G.STATE = G.STATES.GAME_OVER
        if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then
            G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
        end
        G:save_settings()
        G.FILE_HANDLER.force = true
        G.STATE_COMPLETE = false
    end
end

--- General card helpers
ArrowAPI.game = {

    have_multiple_jokers = function(tbl, amount, count_debuffed)
        local found = 0
        for _, v in ipairs(tbl) do
            if next(SMODS.find_card(v, count_debuffed)) then
                found = found + 1
            end
        end

        if amount then
            return found >= amount
        else
            return found == #tbl
        end
    end,

    --- Returns your most played hand and the number of times it was played
    --- @return string | nil hand Key of highest played hand
    --- @return number played number of times played. 0 if hand is nil
    get_most_played_hand = function()
        local hand = 'High Card'
        local played = -1;
        local order = 100;
        for k, v in pairs(G.GAME.hands) do
            if v.played > played or (v.played == played and order < v.order) then
                played = v.played
                hand = k
            end
        end

        if played == 0 then hand = nil end

        return hand, played
    end,

    --- Utility function to check if all cards in hand are of the same suit. DO NOT USE WHEN RETURNING QUANTUM ENHANCEMENTS
    --- @param hand table Array table of Balatro card objects, representing a played hand
    --- @param suit string Key of the suit to check
    --- @return boolean # True if all cards in hand are the same suit
    hand_all_suit = function(hand, suit)
        for k, v in ipairs(hand) do
            if not v:is_suit(suit, nil, true) then
                return false
            end
        end
        return true
    end,

    --- Returns the number of cards of a specified enhancement in your full deck (respects quantum enhancements)
    --- @param enhancement_key string Key of the enhancement in G.P_CENTERS
    --- @return number enhance_tally Number of enhanced cards in your deck
    get_enhanced_tally = function(enhancement_key, include_debuff)
        local enhance_tally = 0

        if not G.playing_cards then
            return enhance_tally
        end

        for k, v in pairs(G.playing_cards) do
            if (include_debuff or not v.debuff) and ((not enhancement_key and v.ability.set == 'Enhanced') or SMODS.has_enhancement(v, enhancement_key)) then
                enhance_tally =  enhance_tally + 1
            end
        end

        return enhance_tally
    end,

    --- Returns the number of cards of a specified rank in your full deck
    --- @param rank_id string id of the rank
    --- @return number enhance_tally Number of ranks in your deck
    get_rank_tally = function(rank_id, include_debuff)
        local rank_tally = 0

        if not G.playing_cards then
            return rank_tally
        end

        for k, v in pairs(G.playing_cards) do
            if (include_debuff or not v.debuff) and v:get_id() == rank_id  then
                rank_tally =  rank_tally + 1
            end
        end

        return rank_tally
    end,

    --- Replaces a card in-place with a card of the specified key
    --- @param card Card Balatro card table of the card to replace
    --- @param to_key string string key (including prefixes) to replace the given card
    --- @param evolve boolean | nil boolean for stand evolution
    --- @param silent boolean | nil boolean for transform juice/sound
    transform_card = function(card, to_key, evolve, silent)
        evolve = evolve or false
        local new_card = G.P_CENTERS[to_key]

        card.T.w = G.CARD_W
        card.T.h = G.CARD_H
        card.original_T = copy_table(card.T)

        for _, v in pairs(card.children) do
            v:remove()
        end

        card:set_ability(new_card)
        card:set_cost()

        if evolve and new_card.on_evolve and type(new_card.on_evolve) == 'function' then
            new_card:on_evolve(card)
        end

        if not card.edition and not silent then
            card:juice_up()
            play_sound('generic1')
        elseif not silent then
            card:juice_up(1, 0.5)
            if card.edition.foil then play_sound('foil1', 1.2, 0.4) end
            if card.edition.holo then play_sound('holo1', 1.2 * 1.58, 0.4) end
            if card.edition.polychrome then play_sound('polychrome1', 1.2, 0.7) end
            if card.edition.negative then play_sound('negative', 1.5, 0.4) end
        end
    end,

    --- Checks total discovered card centers for a given mod
    --- @param mod_id string|nil
    --- @param set string|nil
    --- @param exclude table|nil An SMODS object to exclude from the count (usually the one calling the check)
    --- @return integer discovered Number of currently discovered mod cards
    --- @return integer total Total number of mod cards
    check_mod_discoveries = function(mod_id, set, exclude)
        local count = 0
        local discovered = 0
        for k, v in pairs(G.P_CENTERS) do
            if (not mod_id or (v.original_mod and v.original_mod.id == mod_id))
            and (not set or (v.set == set))
            and (not exclude or k ~= exclude.key) then
                count = count + 1
                if v.discovered and v.unlocked then
                    discovered = discovered + 1
                end
            end
        end

        return discovered, count
    end,

    create_extra_blind = function(blind_source, blind_type, skip_set_blind)
        if not G.GAME then return end
        local new_extra_blind = arrow_init_extra_blind(0, 0, 0, 0, blind_source)

        if not skip_set_blind and G.GAME.blind.in_blind then
            new_extra_blind:extra_set_blind(blind_type)
        else
            new_extra_blind.config.blind = blind_type
            new_extra_blind.name = blind_type.name
            new_extra_blind.debuff = blind_type.debuff
            new_extra_blind.mult = blind_type.mult / 2
            new_extra_blind.disabled = false
            new_extra_blind.discards_sub = nil
            new_extra_blind.hands_sub = nil
            new_extra_blind.boss = not not blind_type.boss
            new_extra_blind.blind_set = false
            new_extra_blind.triggered = nil
            new_extra_blind.prepped = true
            new_extra_blind:set_text()
        end

        G.GAME.arrow_extra_blinds[#G.GAME.arrow_extra_blinds+1] = new_extra_blind
        return new_extra_blind
    end,

    remove_extra_blinds = function(blind_source)
        if not G.GAME then return end
        local removed = false
        for i=#G.GAME.arrow_extra_blinds, 1, -1 do
            if G.GAME.arrow_extra_blinds[i].arrow_extra_blind == blind_source then
                -- disable effect more removal
                local extra_blind = G.GAME.arrow_extra_blinds[i]
                if G.GAME.blind.in_blind then
                    local old_main_blind = G.GAME.blind
                    extra_blind.chips = old_main_blind.chips
                    extra_blind.chip_text = number_format(old_main_blind.chips)
                    extra_blind.dollars = old_main_blind.dollars
                    G.GAME.blind = extra_blind

                    extra_blind:disable()

                    old_main_blind.chips = extra_blind.chips
                    old_main_blind.chip_text = number_format(extra_blind.chips)
                    old_main_blind.dollars = extra_blind.dollars
                    G.GAME.blind = old_main_blind
                end

                table.remove(G.GAME.arrow_extra_blinds, i)

                if blind_source.ability and type(blind_source.ability) == 'table' then
                    blind_source.ability.blind_type = nil
                end
                blind_source.blind_type = nil

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    func = function()
                        extra_blind:remove()
                        return true
                    end
                }))
                removed = true
            end
        end
        return removed
    end,

    --- Sets a discount for specific cards rather than a
    --- global discount and updates all instanced cards' costs
    --- @param source Card Balatro Card table indicating the source of the discount
    --- @param discount number discount percentage. 0 is 0%, 1 is 100%
    --- @param center_set string | nil Set to limit the discount to ('Booster', 'Tarot', 'Joker', etc)
    set_center_discount = function(source, discount, juice, center_set)
        G.GAME.arrow_extra_discounts[source.unique_val] = {
            center_set = center_set,
            discount = discount
        }
        for _, v in pairs(G.I.CARD) do
            if v.set_cost and (not center_set or (v.ability and v.ability.set == center_set)) then
                v:set_cost()
                v:juice_up()
            end
        end
        if juice then play_sound('generic1') end
    end,

    --- Clears any set discounts keyed with source's ID
    --- and updates all instanced cards' costs
    --- @param source Card Balatro Card table indicating the source of the discount
    clear_discount = function(source)
        G.GAME.arrow_extra_discounts[source.unique_val] = nil
        for _, v in pairs(G.I.CARD) do
            if v.set_cost then
                v:set_cost()
            end
        end
    end,

    batch_level_up = function(card, hands, amount)
        amount = amount or 1
        G.GAME.arrow_last_upgraded_hand = {}
        local neg = amount <= 0


        update_hand_text({sound = 'button', volume = 0.7, pitch = neg and 1.4 or 0.8, delay = 0.3}, {
            handname = localize('k_all_hands'),
            chips = '...',
            mult = '...',
            level = ''
        })

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                play_sound('tarot1', neg and 1.5 or nil)
                card:juice_up(0.8, 0.5)
                G.TAROT_INTERRUPT_PULSE = true
                return true
            end
        }))

        update_hand_text({delay = 0}, {
            mult = neg and '-' or '+',
            StatusText = true
        })

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.9,
            func = function()
                play_sound('tarot1', neg and 1.5 or nil)
                card:juice_up(0.8, 0.5)
                return true
            end
        }))

        update_hand_text({delay = 0}, {
            chips = neg and '-' or '+',
            StatusText = true
        })

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.9,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.8, 0.5)
                G.TAROT_INTERRUPT_PULSE = nil
                return true
            end
        }))

        update_hand_text({sound = 'button', volume = 0.7, pitch = neg and 1.5 or 0.9, delay = 0}, {
            level='+1'
        })

        delay(1.3)

        for k, _ in pairs(hands) do
            level_up_hand_bypass(card, k, true, amount == 0 and (-G.GAME.hands[k].level + 1) or amount, true)
            G.GAME.arrow_last_upgraded_hand[k] = true
        end

        update_hand_text({sound = 'button', volume = 0.7, pitch = neg and 2.0 or 1.1, delay = 0}, {
            mult = 0,
            chips = 0,
            handname = '',
            level = ''
        })

        SMODS.calculate_context({hand_upgraded = true, upgraded = hands, amount = amount})
    end,

    consumable_selection_mod = function(mod)
        G.GAME.modifiers.consumable_selection_mod = G.GAME.modifiers.consumable_selection_mod or 0
        for _, v in pairs(G.I.CARD) do
            if v.ability and v.ability.consumeable and v.ability.max_highlighted then
                v.ability.max_highlighted = v.ability.max_highlighted + mod
            end
        end

        G.GAME.modifiers.consumable_selection_mod = G.GAME.modifiers.consumable_selection_mod + mod
    end,

    --- Sets the game over state outside of dedicated game over conditions
    --- @param win boolean | nil Whether to win or lose, default is lose
    --- @param instant boolean | nil Delay game over in an event
    game_over = function(win, instant)
        if instant then
            game_over_handler(win)
            return
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                game_over_handler(win)
                return true
            end
        }))
    end,

    --- Utility function to check if all cards in hand are of the same suit.
    --- @param hand table Array table of Balatro card objects, representing a played hand
    --- @param suit string Key of the suit to check
    --- @return boolean # True if all cards in hand are the same suit
    all_same_suit = function(hand, suit)
        for k, v in ipairs(hand) do
            if not v:is_suit(suit, nil, true) then
                return false
            end
        end
        return true
    end,


    hand_contains_ranks = function(hand, ranks, require_all)
        require_all = require_all or false
        local found = {}

        for _, card in ipairs(hand) do
            if card.ability.effect == "Base" then
                local rank = card:get_id()
                for _, target in ipairs(ranks) do
                    if rank == target then
                        found[target] = true
                    end
                end
            end
        end
        if require_all then
            for _, target in ipairs(ranks) do
                if not found[target] then
                    return false
                end
            end
            return true
        else
            return next(found) ~= nil
        end
    end,

    --- Returns a random tag based on a provided tag type
    --- @param type string | nil supported types are 'joker', 'booster', or 'any'. Joker is default
    --- @param seed string | nil random seed string, uses 'freejokertag' by default
    get_tag_by_type = function(type, seed)
        type = type or 'joker'
        seed = seed or 'freejokertag'
        local _pool, _ = get_current_pool('Tag', nil, nil, seed)
        local real_pool = {}
        for i, v in ipairs(_pool) do
            if v ~= "UNAVAILABLE" then
                if G.P_TAGS[v] then
                    local tag = G.P_TAGS[v]
                    if type == 'joker' and (tag.config.type and ArrowAPI.string.starts_with(tag.config.type, 'store_joker') and (not tag.min_ante or (G.GAME.round_resets.ante >= tag.min_ante)))
                    or type == 'booster' and (tag.config.type == 'new_blind_choice' and (not tag.min_ante or (G.GAME.round_resets.ante >= tag.min_ante)) and v ~= 'tag_boss')
                    or type == 'any' then
                        real_pool[#real_pool+1] = v
                    end
                end
            end
        end
        local key = pseudorandom_element(real_pool, pseudoseed(seed))
	    return key, G.C.TAGS[key] or G.C.IMPORTANT
    end,

    get_lowest_hand_level = function()
        local lowest = 0
        for i=1, #G.handlist do
            if i == 1 then lowest = G.GAME.hands[G.handlist[i]].level end
            if G.GAME.hands[G.handlist[i]].level < lowest then lowest = G.GAME.hands[G.handlist[i]].level end
        end

        return lowest
    end,

    card_expire = function(card, loc_string, colour)
        loc_string = loc_string or 'k_eaten_ex'
        colour = colour or G.C.FILTER
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot1')
                card.T.r = -0.2
                card:juice_up(0.3, 0.4)
                card.states.drag.is = true
                card.children.center.pinch.x = true
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    blockable = false,
                    func = function()
                        if card.area then
                            card.area:remove_card(card)
                        end
                        card:remove()
                        card = nil
                        return true

                    end
                }))
                return true
            end
        }))
        card_eval_status_text(card, 'extra', nil, nil, nil, {
            message = localize(loc_string),
            colour = colour,
            no_juice = true
        })
    end,

    refresh_costs = function()
         G.E_MANAGER:add_event(Event({func = function()
            for k, v in pairs(G.I.CARD) do
                if v.set_cost then v:set_cost() end
            end
            return true
        end }))
    end
}