local achInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        if args.type == "high_tetris" then
            return true
        end
    end,
}

return achInfo