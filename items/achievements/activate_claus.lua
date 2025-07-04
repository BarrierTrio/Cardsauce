local trophyInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        return args.type == 'activate_claus'
    end,
}

return trophyInfo