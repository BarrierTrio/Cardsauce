local achInfo = {
    rarity = 2,
    unlock_condition = function(self, args)
        return args.type == "skin_vineshroom"
    end,
}

return achInfo