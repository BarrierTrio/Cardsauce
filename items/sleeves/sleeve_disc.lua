local sleeveInfo = {
    name = 'DISC Sleeve',
    config = {},
    unlocked = false,
    unlock_condition = { deck = "b_csau_disc", stake = "stake_green" },
    artist = 'BarrierTrio/Gote'
}

sleeveInfo.loc_vars = function(self, info_queue)

    local key = self.key
    self.config = { voucher = 'v_crystal_ball' }
    if self.get_current_deck_key() == "b_csau_disc" then
        key = key .. "_alt"
        self.config.voucher = "v_csau_foo"
    end

    local vars = { localize{type = 'name_text', key = self.config.voucher, set = 'Voucher'} }
    return { key = key, vars = vars }
end

function sleeveInfo.apply(self, sleeve)
    G.GAME.modifiers.csau_unlimited_stands = true
    CardSleeves.Sleeve.apply(sleeve)
end

return sleeveInfo