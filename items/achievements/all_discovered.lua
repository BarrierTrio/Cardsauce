local achInfo = {
    rarity = 4,
    unlock_condition = function(self, args)
        if args.type == "discover_amount" then
            for k, v in pairs(SMODS.Centers) do
                if v.original_mod and v.original_mod.id == 'Cardsauce' and v.set == 'Joker' and not v.no_collection then
                    if not v.discovered or not v.unlocked then
                        return false
                    end
                end
            end

            return true
        end
    end,
}

return achInfo