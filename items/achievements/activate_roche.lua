local achInfo = {
    rarity = 2,
    hidden_text = true,
    unlock_condition = function(self, args)
        return args.type == "activate_roche"
    end,
}

return achInfo