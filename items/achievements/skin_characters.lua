local achInfo = {
    rarity = 2,
    unlock_condition = function(self, args)
        if args.type == "skin_characters" then
            return true
        end
    end,
}

return achInfo