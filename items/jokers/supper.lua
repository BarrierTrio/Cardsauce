local jokerInfo = {
	name = 'WAAUGGHGHHHHGHH',
	atlas = 'jokers',
	pos = {x = 3, y = 8},
	config = {
		extra = {
			procs_this_hand = 0,
			x_mult = 1.5,
			valid_ids = {
				[14] = true,
				[2] = true,
				[4] = true
			}
		},
	},
	rarity = 3,
	cost = 7,
	unlocked = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	has_shiny = true,
	origin = 'cardsauce',
	artist = 'Kekulism',
}

function jokerInfo.check_for_unlock(self, args)
	return args.type == "ante_up" and to_big(args.ante) == to_big(7)
end

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.x_mult} }
end

SMODS.Sound({
	key = "wega",
	path = "wega.ogg",
})

function jokerInfo.calculate(self, card, context)
	if context.before then
		card.ability.extra.procs_this_hand = 0
	end

	if card.debuff then return end

	if context.individual and context.cardarea == G.play and card.ability.extra.valid_ids[context.other_card:get_id()] then
		card.ability.extra.procs_this_hand = card.ability.extra.procs_this_hand + 1
		if card.ability.extra.procs_this_hand >= 10 then
			check_for_unlock({ type = "high_supper" })
		end

		return {
			x_mult = card.ability.extra.x_mult,
			sound = Cardsauce.config['muteWega'] and 'csau_wega' or nil,
			card = context.blueprint_card or card
		}
	end
end



return jokerInfo
