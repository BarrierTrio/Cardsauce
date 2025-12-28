local achInfo = {
    rarity = 4,
    unlock_condition = function(self, args)
        if args.type == "discover_amount" then
            local csauJokers = 0
            local csauDiscovered = 0
            for k, v in pairs(SMODS.Centers) do
                if ArrowAPI.string.starts_with(k, 'j_csau_') then
                    csauJokers = csauJokers + 1
                    if v.discovered == true then
                        csauDiscovered = csauDiscovered + 1
                    end
                end
            end
            if csauDiscovered == csauJokers then
                return true
            end
        end
    end,
}

return achInfo