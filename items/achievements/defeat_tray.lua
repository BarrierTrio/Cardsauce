local achInfo = {
    rarity = 2,
    unlock_condition = function(self, args)
        if args.type == "defeat_tray" then
            return true
        end
    end,
}

return achInfo