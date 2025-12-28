local consumInfo = {
    name = 'Roar',
    atlas = 'vhs',
	pos = {x = 0, y = 1},
    set = "VHS",
    runtime = 3,
    cost = 3,
    config = {},
    origin = {
        category = 'rlm',
        sub_origins = {
            'rlm_botw',
        },
        custom_color = 'rlm'
    },
    artist = 'yunkie101'
}

function consumInfo.calculate(self, card, context)
    if context.filter_draw then
        return {
            rank_min = 6
        }
    end
end

return consumInfo