local achInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        if args.type == "high_feature" then
            return true
        end
    end,
}

return achInfo