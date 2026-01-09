local achInfo = {
    rarity = 2,
    unlock_condition = function(self, args)
        if args.type == "defeat_vod" then
            return true
        end
    end,
}

return achInfo