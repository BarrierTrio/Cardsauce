local achInfo = {
    rarity = 1,
    config = {key = 'c_csau_wwvcr'},
    unlock_condition = function(self, args)
        return args.type == "monkey_butt"
    end,
}

function achInfo.loc_vars(self)
    local key = self.key..(G.P_CENTERS[self.config.key].discovered and '' or '_alt')
    return {
        vars = { },
        key = key
    }
end

return achInfo