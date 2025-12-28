local achInfo = {
    rarity = 2,
    unlock_condition = function(self, args)
        if args.type == "supreme_ascend" then
            return true
        end
    end,
}

return achInfo
