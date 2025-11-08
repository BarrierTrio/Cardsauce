local jokerInfo = {
	name = 'Speed Joker',
	config = {},
	rarity = 1,
	cost = 4,
	unlocked = false,
	unlock_condition = {type = 'discover_sohappy'},
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	has_shiny = true,
	streamer = "vinny",
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.check_for_unlock(self, args)
	return G.FUNCS.discovery_check({ mode = 'key', key = 'j_csau_sohappy' })
end

function jokerInfo.calculate(self, card, context)
	if context.cardarea == G.jokers and context.before and not card.debuff and not context.blueprint then
		G.GAME.csau_sj_drawextra = true
	end
end

return jokerInfo
