local achInfo = {
    rarity = 2,
    unlock_condition = function(self, args)
        return args.type == "reno_colors"
    end,
}

return achInfo