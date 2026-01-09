local blindInfo = {
    name = "The Vod",
    atlas = 'blinds',
    pos = {x = 0, y = 6},
    boss_colour = HEX('418886'),
    dollars = 5,
    mult = 2,
    vars = {},
    debuff = {},
    boss = {min = 3, max = 10}
}

function blindInfo.defeat(self)
    check_for_unlock({ type = "defeat_vod" })
end

function blindInfo.calculate(self, blind, context)
    if context.return_card_to_hand then
		return {
			return_card = true
		}
	end
end

return blindInfo