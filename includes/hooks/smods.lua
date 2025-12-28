function csau_reset_joeycastle()
	if G.GAME.wigsaw_suit then
		G.GAME.current_round.joeycastle = { suit = G.GAME.wigsaw_suit }
		return
	end

	G.GAME.current_round.joeycastle = { suit = 'Clubs' }
	local valid_joeycastle_cards = {}
	for _, v in ipairs(G.playing_cards) do
		if not SMODS.has_no_suit(v) then
			valid_joeycastle_cards[#valid_joeycastle_cards+1] = v
		end
	end

	if #valid_joeycastle_cards > 0 then
		local rand_card = pseudorandom_element(valid_joeycastle_cards, 'fent'..G.GAME.round_resets.ante)
		G.GAME.current_round.joeycastle.suit = rand_card.base.suit
	end
end

function csau_reset_choicevoice()
	G.GAME.current_round.choicevoice = { suit = G.GAME.wigsaw_suit or 'Clubs', rank = 'Ace', id = 14 }

	if #G.playing_cards > 0 then
		local rand_card = pseudorandom_element(G.playing_cards, 'marrriooOOO'..G.GAME.round_resets.ante)
		G.GAME.current_round.choicevoice.suit = G.GAME.wigsaw_suit or rand_card.base.suit
		G.GAME.current_round.choicevoice.rank = rand_card.base.value
		G.GAME.current_round.choicevoice.id = rand_card.base.id
	end
end

function csau_reset_duane()
	if G.GAME.wigsaw_suit then
		G.GAME.current_round.duane_suit = G.GAME.wigsaw_suit
		return
	end

	local rand_card = pseudorandom_element(G.playing_cards, pseudoseed('DUANE'..G.GAME.round_resets.ante)) or { base = {suit = 'Clubs'}}
	G.GAME.csau_delay_duane = true
	SMODS.calculate_context({csau_duane_change = true, suit = rand_card.base.suit})
	G.GAME.current_round.duane_suit = rand_card.base.suit
end

local ref_wrap_straight = SMODS.wrap_around_straight
function SMODS.wrap_around_straight()
	local ret = ref_wrap_straight()
	return ret or next(SMODS.find_card('j_csau_gnorts'))
end


-- total override of this function for bootleg purposes
function SMODS.find_card(key, count_debuffed)
    local results = {}
    if not G.jokers or not G.jokers.cards then return {} end
    for _, area in ipairs(SMODS.get_card_areas('jokers')) do
        if area.cards then
            for _, v in pairs(area.cards) do
                if v and type(v) == 'table' and (v.config.center.key == key or (v.config.center.key == 'j_csau_bootleg' and v.ability.bootlegged_key == key))
				and (count_debuffed or not v.debuff) then
                    table.insert(results, v)
                end
            end
        end
    end
    return results
end





---------------------------
--------------------------- Wigsaw hooks
---------------------------


local ref_change_base = SMODS.change_base
function SMODS.change_base(card, suit, rank, manual_sprites)
    suit = G.GAME.wigsaw_suit or suit
    return ref_change_base(card, suit, rank, manual_sprites)
end

SMODS.Center.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
	if not card then
		card = self:create_fake_card()
	end

	local target = {
		type = 'descriptions',
		key = self.key,
		set = self.set,
		nodes = desc_nodes,
		AUT = full_UI_table,
		vars =
			specific_vars or {}
	}

	local res = {}
	if self.loc_vars and type(self.loc_vars) == 'function' then
		res = self:loc_vars(info_queue, card) or {}
		target.vars = res.vars or target.vars
		target.key = res.key or target.key
		target.set = res.set or target.set
		target.scale = res.scale
		target.text_colour = res.text_colour
	end

	if self.set ~= 'Enhanced' and self.set ~= 'Default' and target.vars and target.vars.colours and G.GAME.wigsaw_suit then
		-- anything that isn't a playing card has its loc vars colours adjusted to the wigsaw suit
		for i, v in ipairs(target.vars.colours) do
			for _, col in pairs(G.C.SUITS) do
				if v == col then
					target.vars.colours[i] = G.C.SUITS[G.GAME.wigsaw_suit]
				end
			end
		end
	end

	if desc_nodes == full_UI_table.main and not full_UI_table.name then
		full_UI_table.name = self.set == 'Enhanced' and 'temp_value' or localize { type = 'name', set = target.set, key = res.name_key or target.key, nodes = full_UI_table.name, vars = res.name_vars or target.vars or {} }
	elseif desc_nodes ~= full_UI_table.main and not desc_nodes.name and self.set ~= 'Enhanced' then
		desc_nodes.name = localize{type = 'name_text', key = res.name_key or target.key, set = target.set }
	end
	if specific_vars and specific_vars.debuffed and not res.replace_debuff then
		target = { type = 'other', key = 'debuffed_' ..
		(specific_vars.playing_card and 'playing_card' or 'default'), nodes = desc_nodes, AUT = full_UI_table, }
	end
	if res.main_start then
		desc_nodes[#desc_nodes + 1] = res.main_start
	end

	localize(target)
	if res.main_end then
		desc_nodes[#desc_nodes + 1] = res.main_end
	end
	desc_nodes.background_colour = res.background_colour
end





---------------------------
--------------------------- One-off Card Helpers
---------------------------

function SMODS.return_to_hand(card, context)
	if not G.GAME.blind.disabled and G.GAME.blind.name == 'The Vod' then
        return true
    elseif G.GAME.fnwk_extra_blinds then
        for _, v in ipairs(G.GAME.fnwk_extra_blinds) do
            if not v.disabled and v.name == 'The Vod' then
                return true
            end
        end
    end

	if ArrowAPI.vhs.find_activated_tape('c_csau_yoyoman') and ArrowAPI.table.contains(context.scoring_hand, card) then return true end
	if context.scoring_name == "High Card" and next(SMODS.find_card("j_csau_besomeone")) and ArrowAPI.table.contains(context.scoring_hand, card) then return true end
	return false
end