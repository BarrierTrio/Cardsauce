local jokers = {
    'j_csau_besomeone',
    'j_csau_garbagehand',
    'j_csau_anotherlight',
    'j_csau_kerosene',
    'j_csau_vincenzo',
    'j_csau_quarterdumb'
}

local achInfo = {
    rarity = 3,
    config = {num = 4},
    unlock_condition = function(self, args)
        if args.type ~= 'modify_deck' then return end
        return ArrowAPI.game.have_multiple_jokers(jokers, self.config.num)
    end,
}

function achInfo.loc_vars(self)
    return { vars = { self.config.num }}
end

return achInfo