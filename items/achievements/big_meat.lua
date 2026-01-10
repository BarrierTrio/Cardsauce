local achInfo = {
    rarity = 4,
    unlock_condition = function(self, args)
        for k, v in pairs(SMODS.Achievements) do
            if k ~= 'ach_csau_big_meat' and v.original_mod and v.original_mod.id == 'Cardsauce' and not v.earned then
                return false
            end
        end

        return true
    end,
}

return achInfo