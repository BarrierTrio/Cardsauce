local achInfo = {
    rarity = 3,
    unlock_condition = function(self, args)
        if args.type == "purchase_dink" then
            return true
        end
    end,
}

return achInfo