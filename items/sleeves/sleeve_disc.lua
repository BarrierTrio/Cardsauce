local sleeveInfo = {
    name = 'DISC Sleeve',
    config = {},
    unlocked = false,
    unlock_condition = { deck = "b_csau_disc", stake = "stake_green" },
    dependencies = {
        config = {
            ['Stands'] = true,
        }
    },
    artist = 'BarrierTrio/Gote'
}

sleeveInfo.loc_vars = function(self, info_queue)
    local matching_deck = self.get_current_deck_key() == "b_csau_disc"

    return {
        key = self.key..(matching_deck and '_alt' or ''),
        vars = {
            localize({
                type = 'name_text',
                key = matching_deck and 'v_csau_foo' or 'v_crystal_ball',
                set = 'Voucher'
            })
        }
     }
end

function sleeveInfo.apply(self, sleeve)
    if self.get_current_deck_key() == "b_csau_disc" then
        self.config.voucher = "v_csau_foo"
    else
        self.config.voucher = 'v_crystal_ball'
    end

    G.GAME.modifiers.csau_unlimited_stands = true
    CardSleeves.Sleeve.apply(sleeve)
end

return sleeveInfo