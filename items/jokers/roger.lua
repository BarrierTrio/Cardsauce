local jokerInfo = {
	name = 'Mr. Roger',
	atlas = 'jokers',
	pos = {x = 0, y = 2},
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
	artist = 'Lyzerus'
}

function jokerInfo.loc_vars(self, info_queue, card)
	if not ArrowAPI.current_config['enabled_DetailedDescs'] then
		info_queue[#info_queue+1] = {key = "rogernote", set = "Other", vars = {next(SMODS.find_card("j_four_fingers")) and 4 or 5}}
	end
	return {
		vars = {card.ability.extra.x_mult, next(SMODS.find_card("j_four_fingers")) and 0.4 or 0.5},
	}
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
