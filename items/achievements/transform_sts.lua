local achInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        if args.type == "transform_sts" then
            return true
        end
    end,
}

return achInfo