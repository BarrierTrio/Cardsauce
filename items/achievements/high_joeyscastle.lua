local achInfo = {
    rarity = 1,
    hidden_text = true,
    unlock_condition = function(self, args)
        return args.type == "high_joeyscastle"
    end,
}

return achInfo