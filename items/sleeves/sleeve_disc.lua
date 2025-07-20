local sleeveInfo = {
    name = 'DISC Sleeve',
    config = {},
    unlocked = false,
    unlock_condition = { deck = "b_csau_disc", stake = "stake_green" },
}

sleeveInfo.loc_vars = function(self, info_queue)
    if info_queue then info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } } end
    
    local key = self.key
    self.config = { voucher = 'v_crystal_ball' }
    if self.get_current_deck_key() == 'b_csau_disc' then
        key = key..'_alt'
        self.config.voucher = 'v_csau_foo'
    end

    local vars = { localize{type = 'name_text', key = self.config.voucher, set = 'Voucher'} }
    return { key = key, vars = vars }
end

function sleeveInfo.apply(self, sleeve)
    G.GAME.modifiers.csau_unlimited_stands = true

    if self.get_current_deck_key() == 'b_csau_disc' then
        G.GAME.starting_params.csau_all_rate = G.GAME.starting_params.csau_all_rate or 1
        G.GAME.starting_params.csau_all_rate = G.GAME.starting_params.csau_all_rate * sleeve.config.csau_all_rate
        sleeve.config.active_mod = sleeve.config.probability_mult_alt
    else
        sleeve.config.active_mod = sleeve.config.probability_mult
    end
    CardSleeves.Sleeve.apply(sleeve)
end

function sleeveInfo.apply(self, back)
    
end

return sleeveInfo