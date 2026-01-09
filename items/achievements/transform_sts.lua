local achInfo = {
    rarity = 1,
    config = {key = 'j_csau_sts'},
    unlock_condition = function(self, args)
        if args.type == "transform_sts" then
            return true
        end
    end,
}

function achInfo.loc_vars(self)
    return { vars = { G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key} or '????????'}}
end

return achInfo