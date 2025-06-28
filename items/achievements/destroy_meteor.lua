local trophyInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        return args.type == 'destroy_meteor'
    end,
}

return trophyInfo