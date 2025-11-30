local trophyInfo = {
    rarity = 4,
    unlock_condition = function(self, args)
        if args.type == "discover_amount" then
            local csauDecks = 0
            local csauDiscovered = 0
            for k, v in pairs(SMODS.Centers) do
                if ArrowAPI.string.starts_with(k, 'b_csau_') then
                    csauDecks = csauDecks + 1
                    if v.discovered == true then
                        csauDiscovered = csauDiscovered + 1
                    end
                end
            end
            if csauDiscovered == csauDecks then
                local decks = 0
                local count = 0
                for k, v in pairs(G.P_CENTERS) do
                    if ArrowAPI.string.starts_with(k, 'b_csau_') and v.set == 'Back' and not v.omit then
                        decks = decks + 1
                        count = count + get_deck_win_stake(v.key)
                    end
                end
                return count >= (decks*8)
            end
        end
    end,
}

return trophyInfo


