local trophyInfo = {
    rarity = 4,
    unlock_condition = function(self, args)
        local all = true
        for k, v in pairs(SMODS.Achievements) do
            if ArrowAPI.string.starts_with(k, 'ach_csau_') then
                if k ~= 'ach_csau_big_meat' and not v.earned then
                    all = false
                end
            end
        end
        return all
    end,
}

return trophyInfo