local jokerInfo = {
	name = 'The NEW Joker!',
	atlas = 'jokers',
	pos = {x = 0, y = 0},
	config = {
		extra = {
			mult = 4
		}
	},
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	has_shiny = true,
	pools = {
		["Meme"] = true
	},
	origin = 'vinny',
	dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
	artist = 'BarrierTrio/Gote'
}


function jokerInfo.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.mult}}
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.individual and context.cardarea == G.play
	and next(SMODS.get_enhancements(context.other_card)) then
		return {
			mult = card.ability.extra.mult,
			card = card
		}
	end
end



return jokerInfo
