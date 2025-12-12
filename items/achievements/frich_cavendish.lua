local achInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        if args.type == "frich_cavendish" then
            return true
        end
    end,
}

return achInfo