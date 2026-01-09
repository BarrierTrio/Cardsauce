local achInfo = {
    rarity = 1,
    hidden_text = true,
    unlock_condition = function(self, args)
        return args.type == "activate_supershow"
    end,
}

return achInfo