local high_one_jokers = {
    'j_csau_besomeone',
    'j_csau_pivot',
    'j_csau_meat',
    'j_csau_dontmind',
}

local trophyInfo = {
    rarity = 2,
    unlock_condition = function(self, args)
        if args.type == 'modify_jokers' and #G.jokers.cards > 0 then
            return G.FUNCS.have_multiple_jokers(high_one_jokers, 2)
        end

        return false
    end,
}

return trophyInfo