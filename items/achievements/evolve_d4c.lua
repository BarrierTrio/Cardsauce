local achInfo = {
    rarity = 2,
    hidden_text = true,
    unlock_condition = function(self, args)
        if args.type == "evolve_d4c" then
            return true
        end
    end,
}

return achInfo