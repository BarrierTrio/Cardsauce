local achInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        if args.type == "expire_grannycream" then
            return true
        end
    end,
}

return achInfo