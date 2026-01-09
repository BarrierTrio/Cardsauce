local achInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        return args.type == "activate_proto"
    end,
}

return achInfo