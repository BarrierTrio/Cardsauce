local trophyInfo = {
    rarity = 1,
    bypass_all_unlocked = true,
    unlock_condition = function(self, args)
        if args.type == "hand_level" then
            if next(SMODS.find_card('j_csau_pivot')) or next(SMODS.find_card('j_csau_dontmind')) then
                if args.hand == "High Card" and args.level < 20 and args.level_after >= 20 then
                    return true
                end
            end
        end
    end,
}

return trophyInfo