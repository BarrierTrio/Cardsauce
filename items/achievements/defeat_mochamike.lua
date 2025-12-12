local achInfo = {
    rarity = 3,
    hidden_text = true,
    unlock_condition = function(self, args)
        if args.type == "defeat_mochamike" then
            return true
        end
    end,
}

return achInfo