local achInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        if args.type == 'hand' and next(SMODS.find_card('j_csau_newjoker')) then
            local enhanced = 0
            for k, v in ipairs(args.scoring_hand) do
                if v.ability.effect ~= "Base" then
                    enhanced = enhanced + 1
                end
            end
            if enhanced >= 5 then
                return true
            end
        end
    end,
}

return achInfo