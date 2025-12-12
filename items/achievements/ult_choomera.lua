local achInfo = {
    rarity = 3,
    unlock_condition = function(self, args)
        if args.type == "ult_choomera" then
            return true
        end
    end,
}

return achInfo