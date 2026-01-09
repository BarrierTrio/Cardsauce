local jokerInfo = {
	name = 'Emmanuel Blast',
	atlas = 'jokers',
	pos = {x = 1, y = 3},
	config = {
		extra = {
			neg_chance = 10,
			cor_chance = 10
		}
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
	info_queue[#info_queue+1] = G.P_TAGS.tag_csau_corrupted
	local num, neg_dom = SMODS.get_probability_vars(card, 1, card.ability.extra.neg_chance, 'csau_blast_negative')
	local _, cor_dom = SMODS.get_probability_vars(card, 1, card.ability.extra.cor_chance, 'csau_blast_corrupted')
	return {
		vars = {
			num, neg_dom,
			localize{type = 'name_text', set = 'Tag', key = 'tag_negative'},
			cor_dom,
			localize{type = 'name_text', set = 'Tag', key = 'tag_csau_corrupted'},
		}
	}
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.end_of_round and context.main_eval then
		local tag = nil
		if SMODS.pseudorandom_probability(card, 'csau_blast_negative', 1, card.ability.extra.neg_chance) then
			tag = 'negative'
		elseif SMODS.pseudorandom_probability(card, 'csau_blast_corrupted', 1, card.ability.extra.cor_chance) then
			tag = 'csau_corrupted'
		end

		if not tag then return end
		check_for_unlock({ type = "activate_eman" })

		return {
			message = localize('k_plus_'..tag),
			colour = HEX('39484e'),
			extra = {
				func = function()
					add_tag(Tag('tag_'..tag))
					play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
					play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
				end
			}
		}
	end
end



return jokerInfo
