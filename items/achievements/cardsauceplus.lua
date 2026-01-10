local achInfo = {
    rarity = 4,
    config = {stake = 8},
    unlock_condition = function(self, args)
        if args.type == "discover_amount" then
            local decks = 0
            local count = 0
            for k, v in pairs(G.P_CENTERS) do
                if v.original_mod and v.original_mod.id == 'Cardsauce' and v.set == 'Back' and not v.omit and not v.no_collection then
                    decks = decks + 1
                    count = count + get_deck_win_stake(v.key)
                end
            end
            return count >= (decks*8)
        end
    end,
}

function achInfo.loc_vars(self)
    return {vars = {
        localize{type = 'name_text', key = SMODS.stake_from_index(self.config.stake), set = 'Stake'},
        colours = {get_stake_col(self.config.stake)}
    }}
end

return achInfo


