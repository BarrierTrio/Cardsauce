local restrict = SMODS.Challenges.c_jokerless_1.restrictions
table.insert(restrict.banned_tags, {id = 'tag_csau_corrupted'})
SMODS.Challenge:take_ownership('jokerless_1', {
    restrictions = restrict
}, true)

SMODS.Consumable:take_ownership('c_ouija', {
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        for i, v in ipairs(G.hand.cards) do
            local percent = 1.15 - (i-0.999)/(#G.hand.cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    v:flip()
                    play_sound('card1', percent)
                    v:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end

        delay(0.2)

        local _rank = pseudorandom_element(SMODS.Ranks, pseudoseed('ouija'))
        for _, v in ipairs(G.hand.cards) do
            G.E_MANAGER:add_event(Event({
                func = function()
                    local change_card = v
                    assert(SMODS.change_base(change_card, nil, _rank.key))
                    return true
                end
            }))
        end

        if SMODS.spectral_downside() then
            G.hand:change_size(-1)
        end

        for i, v in ipairs(G.hand.cards) do
            local percent = 0.85 + (i-0.999)/(#G.hand.cards-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    v:flip()
                    play_sound('tarot2', percent, 0.6)
                    v:juice_up(0.3, 0.3)
                    return true 
                end
            }))
        end

        delay(0.5)
    end
}, true)

SMODS.Consumable:take_ownership('c_familiar', {
    use = function(self, card, area, copier)
        local destroyed_card = nil

        local downside = SMODS.spectral_downside()
        if downside then
            destroyed_card = pseudorandom_element(G.hand.cards, pseudoseed('random_destroy'))
        end
        
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true 
            end
        }))

        if downside and destroyed_card then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function() 
                    if SMODS.shatters(destroyed_card) then
                        destroyed_card:shatter()
                    else
                        destroyed_card:start_dissolve(nil, true)
                    end
                    return true 
                end
            }))
        end 

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = downside and 0.7 or 0,
            func = function() 
                local cards = {}
                for i = 1, card.ability.extra do
                    -- TODO preserve suit vanilla RNG
                    local faces = {}
                    for _, v in ipairs(SMODS.Rank.obj_buffer) do
                        local r = SMODS.Ranks[v]
                        if r.face then table.insert(faces, r) end
                    end
                    local _suit, _rank =
                        pseudorandom_element(SMODS.Suits, pseudoseed('familiar_create')).card_key,
                        pseudorandom_element(faces, pseudoseed('familiar_create')).card_key
                    local cen_pool = {}
                    for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                        if v.key ~= 'm_stone' and not v.overrides_base_rank then
                            cen_pool[#cen_pool + 1] = v
                        end
                    end
                    cards[i] = create_playing_card({
                        front = G.P_CARDS[_suit .. '_' .. _rank],
                        center = pseudorandom_element(cen_pool, pseudoseed('spe_card'))
                    }, G.hand, nil, i ~= 1, { G.C.SECONDARY_SET.Spectral })
                end
                playing_card_joker_effects(cards)
                return true
            end 
        }))

        delay(0.3)

        if downside then
            SMODS.calculate_context({ remove_playing_cards = true, removed = {destroyed_card} })
        end
    end
}, true)

SMODS.Consumable:take_ownership('c_incantation', {
    use = function(self, card, area, copier)
        local destroyed_card = nil

        local downside = SMODS.spectral_downside()
        if downside then
            destroyed_card = pseudorandom_element(G.hand.cards, pseudoseed('random_destroy'))
        end
        
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true 
            end
        }))

        if downside and destroyed_card then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function() 
                    if SMODS.shatters(destroyed_card) then
                        destroyed_card:shatter()
                    else
                        destroyed_card:start_dissolve(nil, true)
                    end
                    return true 
                end
            }))
        end 

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = downside and 0.7 or 0,
            func = function() 
                local cards = {}
                for i=1, card.ability.extra do
                    -- TODO preserve suit vanilla RNG
                    local numbers = {}
                    for _, v in ipairs(SMODS.Rank.obj_buffer) do
                        local r = SMODS.Ranks[v]
                        if v ~= 'Ace' and not r.face then table.insert(numbers, r) end
                    end
                    local _suit, _rank =
                        pseudorandom_element(SMODS.Suits, pseudoseed('incantation_create')).card_key,
                        pseudorandom_element(numbers, pseudoseed('incantation_create')).card_key
                    local cen_pool = {}
                    for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                        if v.key ~= 'm_stone' and not v.overrides_base_rank then
                            cen_pool[#cen_pool + 1] = v
                        end
                    end
                    cards[i] = create_playing_card({
                        front = G.P_CARDS[_suit .. '_' .. _rank],
                        center = pseudorandom_element(cen_pool, pseudoseed('spe_card'))
                    }, G.hand, nil, i ~= 1, { G.C.SECONDARY_SET.Spectral })
                end
                playing_card_joker_effects(cards)
                return true
            end 
        }))

        delay(0.3)

        if downside then
            SMODS.calculate_context({ remove_playing_cards = true, removed = {destroyed_card} })
        end
    end
}, true)

SMODS.Consumable:take_ownership('c_grim', {
    use = function(self, card, area, copier)
        local destroyed_card = nil

        local downside = SMODS.spectral_downside()
        if downside then
            destroyed_card = pseudorandom_element(G.hand.cards, pseudoseed('random_destroy'))
        end
        
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true 
            end
        }))

        if downside and destroyed_card then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function() 
                    if SMODS.shatters(destroyed_card) then
                        destroyed_card:shatter()
                    else
                        destroyed_card:start_dissolve(nil, true)
                    end
                    return true 
                end
            }))
        end 

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = downside and 0.7 or 0,
            func = function() 
                local cards = {}
                for i = 1, card.ability.extra do
                    -- TODO preserve suit vanilla RNG
                    local _suit, _rank =
                        pseudorandom_element(SMODS.Suits, pseudoseed('grim_create')).card_key, 'A'
                    local cen_pool = {}
                    for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                        if v.key ~= 'm_stone' and not v.overrides_base_rank then
                            cen_pool[#cen_pool + 1] = v
                        end
                    end
                    cards[i] = create_playing_card({
                        front = G.P_CARDS[_suit .. '_' .. _rank],
                        center = pseudorandom_element(cen_pool, pseudoseed('spe_card'))
                    }, G.hand, nil, i ~= 1, { G.C.SECONDARY_SET.Spectral })
                end
                playing_card_joker_effects(cards)
                return true
            end 
        }))

        delay(0.3)

        if downside then
            SMODS.calculate_context({ remove_playing_cards = true, removed = {destroyed_card} })
        end
    end
}, true)

SMODS.Consumable:take_ownership('c_ankh', {
    use = function(self, card, area, copier)
        --Need to check for edgecases - if there are max Jokers and all are eternal OR there is a max of 1 joker this isn't possible already
        --If there are max Jokers and exactly 1 is not eternal, that joker cannot be the one selected
        --otherwise, the selected joker can be totally random and all other non-eternal jokers can be removed

        local chosen_joker = pseudorandom_element(G.jokers.cards, pseudoseed('ankh_choice'))
        local downside = SMODS.spectral_downside()
        if downside then
            local deletable_jokers = {}
            for _, v in pairs(G.jokers.cards) do
                if not v.ability.eternal then deletable_jokers[#deletable_jokers + 1] = v end
            end

            local _first_dissolve = nil
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.75,
                func = function()
                    for k, v in pairs(deletable_jokers) do
                        if v ~= chosen_joker and SMODS.will_destroy_card() then
                            check_for_unlock({ type = "unlock_killjester" })
                            v:start_dissolve(nil, _first_dissolve)
                            _first_dissolve = true
                        end
                    end
                    return true
                end
            }))
        end
        
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = downside and 0.4 or 0,
            func = function()
                local new_copy = copy_card(chosen_joker, nil, nil, nil, chosen_joker.edition and chosen_joker.edition.negative)
                new_copy:start_materialize()
                new_copy:add_to_deck()
                if new_copy.edition and new_copy.edition.negative then
                    new_copy:set_edition(nil, true)
                end
                G.jokers:emplace(new_copy)
                return true
            end
        }))
    end
}, true)

SMODS.Consumable:take_ownership('c_hex', {
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local eligible_card = pseudorandom_element(card.eligible_editionless_jokers, pseudoseed('hex'))
                eligible_card:set_edition({polychrome = true}, true)
                check_for_unlock({type = 'have_edition'})

                if SMODS.spectral_downside() then 
                    local _first_dissolve = nil
                    for k, v in pairs(G.jokers.cards) do
                        if v ~= eligible_card and (not v.ability.eternal) and SMODS.will_destroy_card() then
                            check_for_unlock({ type = "unlock_killjester" })
                            v:start_dissolve(nil, _first_dissolve)
                            _first_dissolve = true
                            
                        end
                    end
                end

                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        delay(0.6)
    end
}, true)

SMODS.Consumable:take_ownership('c_ectoplasm', {
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local eligible_card = pseudorandom_element(card.eligible_editionless_jokers, pseudoseed('ectoplasm'))
                eligible_card:set_edition({negative = true}, true)
                check_for_unlock({type = 'have_edition'})

                if SMODS.spectral_downside() then 
                    G.GAME.ecto_minus = G.GAME.ecto_minus or 1
                    G.hand:change_size(-G.GAME.ecto_minus)
                    G.GAME.ecto_minus = G.GAME.ecto_minus + 1
                end

                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        delay(0.6)
    end
}, true)

SMODS.Consumable:take_ownership('c_wraith', {
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                local new_rare = create_card('Joker', G.jokers, nil, 0.99, nil, nil, nil, 'wra')
                new_rare:add_to_deck()
                G.jokers:emplace(new_rare)
                card:juice_up(0.3, 0.5)
                if G.GAME.dollars ~= 0 and SMODS.spectral_downside() then
                    ease_dollars(-G.GAME.dollars, true)
                end
                return true
            end
        }))
        delay(0.6)
    end
}, true)

SMODS.Consumable:take_ownership('c_immolate', {
    use = function(self, card, area, copier)
        check_for_unlock({type = 'unlock_kings'})
        local destroyed_cards = {}
        local downside = SMODS.spectral_downside()
        if downside then
            local temp_hand = {}
            for _, v in ipairs(G.hand.cards) do
                temp_hand[#temp_hand+1] = v 
            end
            table.sort(temp_hand, function (a, b) return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card end)
            pseudoshuffle(temp_hand, pseudoseed('immolate'))

            for i = 1, card.ability.extra.destroy do
                destroyed_cards[#destroyed_cards+1] = temp_hand[i]
            end
        end       

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = downside and 0.4 or 0,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true  
            end
        }))

        if downside then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function() 
                    for i=#destroyed_cards, 1, -1 do
                        local card = destroyed_cards[i]
                        if SMODS.shatters(card) then
                            card:shatter()
                        else
                            card:start_dissolve(nil, i == #destroyed_cards)
                        end
                    end
                    return true
                end
            }))
            delay(0.5)
        end
        
        ease_dollars(card.ability.extra.dollars)

        delay(0.3)

        if downside then
            SMODS.calculate_context({ remove_playing_cards = true, removed = destroyed_cards })
        end
    end
}, true)

SMODS.Joker:take_ownership('j_perkeo', {
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = 1}}
		return { vars = {card.ability.extra}}
	end,

	calculate = function(self, card, context)
		if not context.ending_shop or #G.consumeables.cards < 1 then
			if not context.repetition then
				return nil, true
			end

			return
		end

		local valid_consumeables = {}
		for _, v in ipairs(G.consumeables.cards) do
			if v.ability.set ~= 'csau_Stand' then
				valid_consumeables[#valid_consumeables+1] = v
			end
		end

		if #valid_consumeables > 0 then
			G.E_MANAGER:add_event(Event({
				func = function()
					local copied_card = copy_card(pseudorandom_element(valid_consumeables, pseudoseed('perkeo')), nil)
					copied_card:set_edition({negative = true}, true)
					copied_card:add_to_deck()
					G.consumeables:emplace(copied_card)
					return true
				end}))
			card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_duplicated_ex')})
		end
		return nil, true
	end
}, true)