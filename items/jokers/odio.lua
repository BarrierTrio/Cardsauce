local jokerInfo = {
	name = 'Odious Joker',
	atlas = 'jokers',
	pos = {x = 2, y = 6},
	config = {
		extra = {
			form = 0,
			spawn_3 = {key = 'c_emperor', num = 2},
			spawn_6 = {key = 'c_strength', num = 3},
			spawn_8 = {key = 'c_death', num = 3},
			mult_mod = 5,
			x_mult = 1.5
		}
	},
	rarity = 3,
	cost = 6,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = false,
	origin = 'cardsauce',
}

local function update_odio(center, card, x_off)
	G.E_MANAGER:add_event(Event({
		func = function()
			local y_off = x_off > 8 and x_off % 8 or 0
			card.children.center:set_sprite_pos({x = center.pos.x + x_off, y = center.pos.y + y_off})
			return true
		end
	}))
end

function jokerInfo.in_pool(self, args)
	return to_big(G.GAME.round_resets.ante) < to_big(9)
end

function jokerInfo.load(self, card, card_table, other_card)
	update_odio(self, card, card_table.ability.extra.form - 1)
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.setting_blind and not context.blueprint and G.GAME.blind:get_type() == 'Boss'
	and G.GAME.round_resets.ante > 1 and G.GAME.round_resets.ante < 10 then
		card.ability.extra.form = G.GAME.round_resets.ante

		local spawn_table = card.ability.extra['spawn_'..card.ability.extra.form]
		if spawn_table then
			for i = 1, spawn_table.num do
				SMODS.add_card{key = spawn_table.key, edition = 'e_negative'}
			end
		end

		update_odio(self, card, card.ability.extra.form - 1)

		if card.ability.extra.form == 9 then
			check_for_unlock({ type = "final_odio" })
		end

		return {
			message = localize('k_odio'..card.ability.extra.form),
			colour = G.C.PURPLE
		}
	end

	if context.individual and context.cardarea == G.play and card.ability.extra.form == 2  then
		local big_card = nil
		for k, v in ipairs(context.full_hand) do
			if (not big_card or v.base.nominal > big_card.base.nominal) and not SMODS.has_no_rank(v) then big_card = v end
		end

		if not big_card or big_card.debuff or context.other_card ~= big_card then return end

		return {
			mult = big_card.base.nominal,
			card = card,
		}
	end

	if context.joker_main and card.ability.extra.form == 4 then
		local slot_mult = (5 - #context.full_hand) * card.ability.extra.mult_mod
		if slot_mult > 0 then
			return {
				mult = slot_mult
			}
		end
	end

	if context.before and card.ability.extra.form == 5 then
		local faces = {}
		for _, v in ipairs(context.scoring_hand) do
			if v:is_face() then
				faces[#faces+1] = v

				v:set_ability(G.P_CENTERS.m_glass, nil, true)
				G.E_MANAGER:add_event(Event({
					func = function()
						v:juice_up()
						return true
					end
				}))
			end
		end

		if #faces > 0 then
			return {
				message = localize('k_glass'),
				colour = G.C.RED,
				card = card
			}
		end
	end

	if context.other_joker and card ~= context.other_joker and card.ability.extra.form == 7 then
		return {
			x_mult = card.ability.extra.x_mult
		}
	end

	if context.selling_self and card.ability.extra.form == 9 and G.STATE == G.STATES.SELECTING_HAND then
		G.GAME.chips = G.GAME.blind.chips
		G.STATE = G.STATES.HAND_PLAYED
		G.STATE_COMPLETE = true
		end_round()
	end
end

return jokerInfo
