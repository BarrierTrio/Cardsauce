local mod = SMODS.current_mod

local jokerInfo = {
	name = 'Mr. Roger',
	config = {
		extra = {
			x_mult = 1,
		}
	},
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
	if not mod.config['detailedDescs'] then
		info_queue[#info_queue+1] = {key = "rogernote", set = "Other", vars = {next(SMODS.find_card("j_four_fingers")) and 4 or 5}}
	end
	info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.lyzerus } }
	return { vars = {card.ability.extra.x_mult, next(SMODS.find_card("j_four_fingers")) and 0.4 or 0.5} }
end

function jokerInfo.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
	G.FUNCS.csau_generate_detail_desc(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_roger" })
end

function jokerInfo.calculate(self, card, context)
	if context.joker_main and context.cardarea == G.jokers and not card.debuff then
		if not context.blueprint then
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.0,
				func = (function()
					card.ability.extra.x_mult = 1 + (next(SMODS.find_card("j_four_fingers")) and 0.4 or 0.5)*(G.GAME.current_round.hands_played)
					return true
				end)}
			))
		end
		if to_big(card.ability.extra.x_mult) > to_big(1) then
			return {
				message = localize{type='variable',key='a_xmult',vars={to_big(card.ability.extra.x_mult)}},
				Xmult_mod = card.ability.extra.x_mult,
			}
		end
	end
	if context.end_of_round and not context.blueprint and to_big(card.ability.extra.x_mult) > to_big(1) then
		card.ability.extra.x_mult = 1
		return {
			message = localize('k_reset'),
			colour = G.C.RED
		}
	end
end



return jokerInfo
	