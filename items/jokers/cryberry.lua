local jokerInfo = {
	name = 'Cryberries [WIP]',
	config = {},
	rarity = 1,
	cost = 0,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	origin = 'vinny',
	dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
}

function jokerInfo.calculate(self, card, context)
	--todo
end

return jokerInfo
