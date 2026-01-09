local achInfo = {
    rarity = 1,
    config = {num = 3},
    unlock_condition = function(self, args)
        if G.consumeables then
            local count = 0
            for i, v in ipairs(G.consumeables.cards) do
                if v.ability.set == "VHS" then
                    count = count + 1
                    if count >= self.config.num then
                        return true
                    end
                end
            end
        end
    end,
}

function achInfo.loc_vars(self)
    return { vars = { self.config.num }}
end

return achInfo