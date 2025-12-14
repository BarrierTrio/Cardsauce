local jokerInfo = {
	name = 'Emmanuel Blast',
	atlas = 'jokers',
	pos = {x = 1, y = 3},
	config = {
		extra = 8
	},
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	origin = {
        category = 'cardsauce',
        sub_origins = {
            'vinny',
        },
        custom_color = 'vinny'
    },
	dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
	artist = 'Gappie',
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = G.P_TAGS.tag_negative
	return { vars = {SMODS.get_probability_vars(card, 1, card.ability.extra, 'csau_blast')} }
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.end_of_round and context.main_eval
	and SMODS.pseudorandom_probability(card, 'csau_blast', 1, card.ability.extra) then
		check_for_unlock({ type = "activate_eman" })
		return {
			message = localize('k_plus_negative'),
			colour = HEX('39484e'),
			extra = {
				func = function()
					add_tag(Tag('tag_negative'))
					play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
					play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
				end
			}
		}
	end
end



return jokerInfo
