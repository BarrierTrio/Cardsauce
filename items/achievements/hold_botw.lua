local achInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        if G.consumeables then
            local count = 0
            for i, v in ipairs(G.consumeables.cards) do
                if v.ability.set == "VHS" then
                    count = count + 1
                end
            end
            return count == 3
        end
    end,
}

return achInfo