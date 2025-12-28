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
                local jokers = 0
                local count = 0
                for k, v in pairs(G.P_CENTERS) do
                    if ArrowAPI.string.starts_with(k, 'j_csau_') and v.set == 'Joker' and not v.omit and not v.no_collection then
                        jokers = jokers + 1
                        count = count + get_joker_win_sticker(v, true)
                    end
                end
                return count >= (jokers*8)
            end
        end
    end,
}

return achInfo


