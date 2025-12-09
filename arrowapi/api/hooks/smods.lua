function ArrowAPI.reset_game_globals(run_start)
    if run_start then
        G.GAME.arrow_extra_discounts = {}
        G.GAME.arrow_extra_blinds = G.GAME.arrow_extra_blinds or {}
        G.GAME.modifiers.max_stands = G.GAME.modifiers.max_stands or 1
        G.GAME.modifiers.consumable_selection_mod = G.GAME.modifiers.consumable_selection_mod or 0
        G.GAME.arrow_last_upgraded_hand = {}
    end

    G.GAME.shop_dollars_spent = 0
    G.GAME.rerolls_this_round = 0
end

function ArrowAPI.set_ability_reset_keys()
    return {
        'evolved'
    }
end

local ref_card_collection_uibox = SMODS.card_collection_UIBox
SMODS.card_collection_UIBox = function(_pool, rows, args)
    if _pool == G.P_CENTER_POOLS.Stand then
        args.modify_card = function(card, center, i, j)
            card.sticker = ArrowAPI.stands.get_win_sticker(center)
        end
    end
    return ref_card_collection_uibox(_pool, rows, args)
end



---------------------------
--------------------------- Adding mod badges to galdur interface
---------------------------

local ref_mod_badges = SMODS.create_mod_badges
function SMODS.create_mod_badges(obj, badges)
    local ret = ref_mod_badges(obj, badges)
    if obj and obj.origin then
        badges[#badges+1] = ArrowAPI.ui.dynamic_badge(obj)
    end
    return ret
end





---------------------------
--------------------------- Hand level modification behavior
---------------------------

function SMODS.get_effective_hand_level(base_level, optional_contexts)
    local context = {mod_handlevel = true, numerator = base_level}
    if optional_contexts and type(optional_contexts) == 'table' then
        for k, v in pairs(optional_contexts) do
            context[k] = v
        end
    end
    local mod_level = SMODS.calculate_context(context)
    mod_level.numerator = mod_level.numerator or base_level
    return mod_level.numerator
end





---------------------------
--------------------------- Added calculation flags
---------------------------

local new_calc_flags = {
    'prevent_downside',
    'prevent_expire',
    'blind_hidden',
    'title_center',
    'title_front',
    'splash_center',
    'splash_front',
}

for i=1, #new_calc_flags do
    local flag = new_calc_flags[i]
    table.insert(SMODS.other_calculation_keys, 17, flag)
    SMODS.silent_calculation[flag] = true
end


local ref_context_flags = SMODS.update_context_flags
function SMODS.update_context_flags(context, flags)
    local ret = ref_context_flags(context, flags)

    if flags.prevent_downside ~= nil then context.prevent_downside = flags.prevent_downside end
    if flags.prevent_expire ~= nil then context.prevent_expire = flags.prevent_expire end
    if flags.blind_hidden  ~= nil then context.blind_hidden = flags.blind_hidden end

    if flags.title_card then
        context.title_center = flags.title_center
        context.title_front = flags.title_front
    end

    if flags.splash_card then
        context.splash_center = flags.splash_center
        context.splash_front = flags.splash_front
    end

    return ret
end

function SMODS.spectral_downside(card, check)
    local downside = true
    local flags = SMODS.calculate_context({spectral_downside = true, card = card, downside = downside, check = check})
    if flags.prevent_downside then downside = not flags.prevent_downside end
	return downside
end

function SMODS.food_expires(card, check)
    local expires = true
    local flags = SMODS.calculate_context({food_expires = true, card = card, expires = expires, check = check})
    if flags.prevent_expire then expires = not flags.prevent_expire end
	return expires
end

function SMODS.blind_hidden(blind)
    local hidden = false
    local flags = SMODS.calculate_context({blind_hidden = true, blind_obj = blind, hidden = hidden})
    if flags.blind_hidden then hidden = not flags.blind_hidden end
	return hidden
end

function SMODS.filter_draw(draw_num)
    local calc_return = {}
    SMODS.calculate_context({
        filter_draw = true,
        num_cards = draw_num,
        rank_min = -100,
        rank_max = 1000000,
        enhancements = {},
        editions = {},
        seals = {}
    }, calc_return)

    local requirements = {}
    for _, eval in pairs(calc_return) do
        for key, eval2 in pairs(eval) do
            if key == 'enhancements' or key == 'editions' or key == 'seals' then
                requirements[key] = requirements[key] or {}
                for key2, _ in pairs(eval2) do
                    requirements[key][key2] = true
                end
            elseif key == 'rank_min' then
                requirements.rank_min = math.max(requirements.rank_min or -100, eval2)
            elseif key == 'rank_max' then
                requirements.rank_max = math.min(requirements.rank_max or 1000000, eval2)
            elseif key == 'is_face' then
                requirements.is_face = requirements.is_face or eval2
            end
        end
    end

    if not next(requirements) then return end

    local offset = 0

	for i = 1, #G.deck.cards do
        local idx = #G.deck.cards - offset
		local card = G.deck.cards[idx]
        local has_rank = not SMODS.has_no_rank(card)
		local results = {
            is_face = requirements.is_face and card:is_face() or true,
            rank_min = requirements.rank_min and (has_rank and card.base.id >= requirements.rank_min or false) or true,
            rank_max = requirements.rank_max and (has_rank and card.base.id <= requirements.rank_max or false) or true,
            enhancement = requirements.enhancement and requirements.enhancement[card.config.center.key] or true,
            edition = requirements.edition and requirements.edition[card.edition.key] or true,
            seal = requirements.seal and requirements.seal[card.seal] or true
        }

		local requirements_met = true
		for _, met in pairs(results) do
			if not met then
				requirements_met = false
				break
			end
		end

		if requirements_met then
            offset = offset + 1
            if offset >= draw_num then return end
		else
			table.remove(G.deck.cards, idx)
			table.insert(G.deck.cards, 1, card)
		end
	end
end

local ref_indv_eff = SMODS.calculate_individual_effect
SMODS.calculate_individual_effect = function(effect, scored_card, key, amount, from_edition)
    local ret = ref_indv_eff(effect, scored_card, key, amount, from_edition)
    if ret then return ret end

    if key == 'prevent_downside' or key == 'prevent_expire' or key == 'blind_hidden' then
        return key
    end

    if key == 'title_center' or key == 'title_front' and key == 'splash_center' or key == 'splash_front' then
        return { [key] = amount }
    end
end



