local trophyInfo = {
    rarity = 3,
    bypass_all_unlocked = true,
    unlock_condition = function(self, args)
        if args.type == 'win_deck' then
            if get_deck_win_stake('b_csau_vine') then
                return true
            end
        end
    end,
}

return trophyInfo