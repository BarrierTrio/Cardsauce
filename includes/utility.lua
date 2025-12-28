---------------------------
--------------------------- Loading/Debug Functions
---------------------------

SMODS.Gradient({
	key = 'ortalab_1',
	colours = {
		HEX('990000'),
		HEX('990000')
	}
})

SMODS.Gradient({
	key = 'ortalab_2',
	colours = {
		HEX('E28585'),
		HEX('E28585')
	}
})

function create_dummy_ortalab(file_key, item_type, info)
	if item_type == 'Joker' then
		SMODS.Joker({
			key = file_key..'_locked',
			pos = {x = 8, y = 9},
			loc_txt = {
				name = 'Locked',
				text = {'{s:1.1}Install {E:1,s:1.3,C:csau_ortalab_1}Ortalab'}
			},
			discovered = true,
			no_doe = true,
			rarity = (info and info.rarity) or nil,
			in_pool = function(self)
				return false
			end,
			set_badges = function(self, card, badges)
				if card.area and card.area == G.jokers or card.config.center.discovered then
					badges[#badges+1] = create_badge('Ortalab', HEX('990000'), HEX('E28585'), 0.9 )
				end
			end
		})
	end
end