local blindInfo = {
    name = "The Vod",
    atlas = 'blinds',
    pos = {x = 0, y = 6},
    color = HEX('418886'),
    dollars = 5,
    mult = 2,
    vars = {},
    debuff = {},
    boss = {min = 3, max = 10}
}

function blindInfo.defeat(self)
    check_for_unlock({ type = "defeat_vod" })
end

return blindInfo