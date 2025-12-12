local achInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        if args.type == "destroy_killer" then
            return true
        end
    end,
}

return achInfo