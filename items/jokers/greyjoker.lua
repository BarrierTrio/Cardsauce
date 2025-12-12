local jokerInfo = {
	name = 'Grey Joker',
	atlas = 'jokers',
	pos = {x = 0, y = 1},
	soul_pos = {x = 1, y = 1},
	config = {extra = 3},
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	origin = 'vinny',
	dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
	artist = 'SagaciousCejai'
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra} }
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.setting_blind then
		ease_discard(card.ability.extra)
		return {
			message = "+"..card.ability.extra.." "..localize('k_hud_discards'),
			card = context.blueprint_card or card
		}
	end
end

return jokerInfo
