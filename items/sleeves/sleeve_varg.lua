local sleeveInfo = {
    name = 'Varg Sleeve',
    config = { 
        probability_mult = 2,
        probability_mult_alt = 1.5,
        csau_jokers_rate = 2,
        csau_all_rate = 2,
        hand_size = -1
    },
    unlocked = false,
    unlock_condition = { deck = "b_csau_varg", stake = "stake_green" },
}

function sleeveInfo.loc_vars(self, info_queue)
    if info_queue then
        info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku } }
    end

    local key, vars
    if self.get_current_deck_key() == "b_csau_varg" then
        key = self.key .. "_alt"
        vars = {self.config.probability_mult_alt, self.config.csau_all_rate}
    else
        key = self.key
        vars = {self.config.hand_size, self.config.probability_mult, self.config.csau_jokers_rate}
    end

    return { key = key, vars = vars }
end

function sleeveInfo.apply(self, sleeve)
    if (sleeve.config.csau_jokers_rate) then
        G.GAME.starting_params.csau_jokers_rate = G.GAME.starting_params.csau_jokers_rate or 1
        G.GAME.starting_params.csau_jokers_rate = G.GAME.starting_params.csau_jokers_rate * sleeve.config.csau_jokers_rate
    end
    if self.get_current_deck_key() == "b_csau_varg" then
        G.GAME.starting_params.csau_all_rate = G.GAME.starting_params.csau_all_rate or 1
        G.GAME.starting_params.csau_all_rate = G.GAME.starting_params.csau_all_rate * sleeve.config.csau_all_rate
        sleeve.config.active_mod = sleeve.config.probability_mult_alt
    else
        sleeve.config.active_mod = sleeve.config.probability_mult
    end
    CardSleeves.Sleeve.apply(sleeve)
end

function sleeveInfo.calculate(self, sleeve, context)
    if context.mod_probability then
        return {
            numerator = context.numerator * seleve.config.active_mod
        }
    end
end

return sleeveInfo