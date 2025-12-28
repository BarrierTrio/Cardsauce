local sleeveInfo = {
    name = 'Vine Sleeve',
    atlas = 'sleeves',
    pos = {x = 0, y = 0},
    config = {
        csau_jokers_rate = 3,
        csau_all_rate = 3
    },
    unlocked = false,
    unlock_condition = { deck = "b_csau_vine", stake = "stake_green" },
    artist = 'Kekulism',
}

function sleeveInfo.loc_vars(self, info_queue)
    local matching_deck = self.get_current_deck_key() == "b_csau_vine"

    return {
        key = self.key..(matching_deck and '_alt' or ''),
        vars = {
            matching_deck and self.config.csau_jokers_rate or self.config.csau_all_rate,
            localize({
                type = 'name_text',
                key =  matching_deck and 'v_overstock_plus' or 'v_overstock_norm',
                set = 'Voucher'
            })
        }
    }
end

function sleeveInfo.apply(self, sleeve)
    if self.get_current_deck_key() == "b_csau_vine" then
        G.GAME.starting_params.csau_jokers_rate = (G.GAME.starting_params.csau_jokers_rate or 1)  * sleeve.config.csau_jokers_rate
        self.config.voucher = 'v_overstock_plus'
    else
        G.GAME.starting_params.csau_all_rate = (G.GAME.starting_params.csau_all_rate or 1) * sleeve.config.csau_all_rate
        self.config.voucher = 'v_overstock_norm'
    end

    CardSleeves.Sleeve.apply(sleeve)
end

return sleeveInfo