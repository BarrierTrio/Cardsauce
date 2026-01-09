local achInfo = {
    rarity = 1,
    config = {key = 'j_csau_newjoker', val = 5},
    unlock_condition = function(self, args)
        if args.type == 'hand' and next(SMODS.find_card(self.config.key)) then
            local enhanced = 0
            for k, v in ipairs(args.scoring_hand) do
                if v.ability.effect ~= "Base" then
                    enhanced = enhanced + 1
                    if enhanced >= self.config.val then return true end
                end
            end
        end
    end,
}

function achInfo.loc_vars(self)
    return { vars = {
        G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key} or '????????',
        self.config.val
    }}
end

return achInfo