local voucherInfo = {
    name = 'Plant Appraiser',
    cost = 10,
    requires = {'v_csau_foo'},
    config = {
        extra = {
            rate = 0.12,
        }
    },
    part = 'lion',
    unlocked = false,
    unlock_condition = {type = 'c_stands_bought', extra = 25},
    csau_dependencies = {
        'enableStands',
    },
    artist = 'BarrierTrio/Gote'
}

function voucherInfo.locked_loc_vars(self, info_queue, card)
    return { vars = { self.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_stands_bought or 0} }
end

function voucherInfo.redeem(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = (function()
            G.GAME.csau_evolvedrarity_mod = G.GAME.csau_evolvedrarity_mod + card.ability.extra.rate
            return true
        end)
    }))
end

return voucherInfo