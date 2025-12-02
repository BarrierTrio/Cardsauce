local mod = SMODS.current_mod

local jokerInfo = {
	name = 'WAAUGGHGHHHHGHH',
	atlas = 'jokers',
	pos = {x = 3, y = 8},
	config = {
		extra = {
			x_mult = 1.5
		},
		proc = 0
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
	if args.type == "ante_up" and to_big(args.ante) == to_big(7) then
		return true
	end
end

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.x_mult} }
end

SMODS.Sound({
	key = "wega",
	path = "wega.ogg",
})

function jokerInfo.calculate(self, card, context)
	if context.individual and context.cardarea == G.play and not card.debuff then
		if context.other_card:get_id() == 2 or context.other_card:get_id() == 4 or context.other_card:get_id() == 14 then
			card.ability.proc = card.ability.proc + 1
			if card.ability.proc >= 10 then
				check_for_unlock({ type = "high_supper" })
			end
			local pitch = 1
			local volume = (G.SETTINGS.SOUND.volume/100.0) * (G.SETTINGS.SOUND.game_sounds_volume/100.0)
			if mod.config['muteWega'] then
				return {
					xmult = card.ability.extra.x_mult
				}
			else
				return {
					xmult_message = {message = localize{type='variable',key='a_xmult',vars={to_big(card.ability.extra.x_mult)}}, colour = G.C.MULT, sound = "csau_wega", volume = volume, pitch = pitch},
					x_mult = card.ability.extra.x_mult,
					card = card
				}
			end
		end
	end
	if context.after then
		card.ability.proc = 0
	end
end



return jokerInfo
