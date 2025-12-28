local achInfo = {
    rarity = 3,
    unlock_condition = function(self, args)
        if args.type == "sts_allforms" then
            return true
        end
    end,
}

return achInfo