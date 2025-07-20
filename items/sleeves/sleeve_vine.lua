local sleeveInfo = {
    name = 'Vine Sleeve',
    config = { csau_jokers_rate = 3, csau_all_rate = 3, },
    unlocked = false,
    unlock_condition = { deck = "b_csau_vine", stake = "stake_green" },
}

sleeveInfo.loc_vars = function(self, info_queue)
    if info_queue then
        info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku } }
    end

    local key = self.key
    local rate = self.config.csau_jokers_rate
    self.config.voucher = "v_overstock_norm"

    if self.get_current_deck_key() == "b_csau_vine" then
        key = key .. "_alt"
        self.config.voucher = "v_overstock_plus"
    end

    local vars = {rate, localize{type = 'name_text', key = self.config.voucher, set = 'Voucher'}}
    return { key = key, vars = vars }
end

sleeveInfo.apply = function(self, sleeve)
    if (sleeve.config.csau_jokers_rate) then
        G.GAME.starting_params.csau_jokers_rate = G.GAME.starting_params.csau_jokers_rate or 1
        G.GAME.starting_params.csau_jokers_rate = G.GAME.starting_params.csau_jokers_rate * sleeve.config.csau_jokers_rate
    end
    if self.get_current_deck_key() == "b_csau_varg" then
        G.GAME.starting_params.csau_all_rate = G.GAME.starting_params.csau_all_rate or 1
        G.GAME.starting_params.csau_all_rate = G.GAME.starting_params.csau_all_rate * sleeve.config.csau_all_rate
    end
    CardSleeves.Sleeve.apply(sleeve)
end

return sleeveInfo