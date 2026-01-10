local achInfo = {
    rarity = 2,
    unlock_condition = function(self, args)
        return args.type == "fuckingkill_jimbo"
    end,
}

return achInfo

