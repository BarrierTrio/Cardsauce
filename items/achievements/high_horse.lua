local trophyInfo = {
    rarity = 2,
    unlock_condition = function(self, args)
        return args.type == 'high_horse'
    end,
}

return trophyInfo