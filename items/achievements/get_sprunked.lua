local achInfo = {
    rarity = 2,
    unlock_condition = function(self, args)
        return args.type == "get_sprunked"
    end,
}

return achInfo