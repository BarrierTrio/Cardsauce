local achInfo = {
    rarity = 2,
    unlock_condition = function(self, args)
        return args.type == "skin_characters"
    end,
}

return achInfo