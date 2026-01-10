local achInfo = {
    rarity = 2,
    config = {key = 'j_csau_supper'},
    unlock_condition = function(self, args)
        if args.type ~= 'have_edition' then return end
        local cards = SMODS.find_card(self.config.key)
        if cards and #cards > 0 then
            for i, v in ipairs(cards) do
                if v.edition and v.edition.type == 'negative' then
                    return true
                end
            end
        end
    end,
}

function achInfo.loc_vars(self)
    return { vars = {
        G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key} or '????????',
    }}
end

return achInfo