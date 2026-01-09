local achInfo = {
    rarity = 1,
    config = {key = 'c_csau_topslots'},
    unlock_condition = function(self, args)
        return args.type == "the_scot"
    end,
}

function achInfo.loc_vars(self)
    return { vars = { G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'VHS', key = self.config.key} or '????????'}}
end


return achInfo