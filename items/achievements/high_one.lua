local high_one_jokers = {
    'j_csau_besomeone',
    'j_csau_pivot',
    'j_csau_meat',
    'j_csau_dontmind',
}

local achInfo = {
    rarity = 2,
    config = {num = 2},
    unlock_condition = function(self, args)
        if args.type == 'modify_jokers' and #G.jokers.cards > 0 then
            return ArrowAPI.game.have_multiple_jokers(high_one_jokers,self.config.num)
        end

        return false
    end,
}

function achInfo.loc_vars(self)
    return {
        vars = {
            self.config.num
        }
    }
end

return achInfo