local achInfo = {
    rarity = 3,
    unlock_condition = function(self, args)
        if args.type == "five_deathcard" then
            return true
        end
    end,
}

return achInfo