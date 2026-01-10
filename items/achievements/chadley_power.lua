local achInfo = {
    rarity = 3,
    unlock_condition = function(self, args)
        return args.type == "chadley_power"
    end,
}

return achInfo