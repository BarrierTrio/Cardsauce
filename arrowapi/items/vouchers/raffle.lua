local voucherInfo = {
    name = 'Raffle',
    cost = 10,
    atlas = 'arrow_vouchers',
    prefix_config = {atlas = false},
    pos = {x = 1, y = 1},
    requires = {'v_arrow_scavenger'},
    unlocked = false,
    unlock_condition = {type = 'c_vhss_bought', extra = 25},
    origin = {
        category = 'rlm',
        sub_origins = {
            'rlm_botw',
        },
        custom_color = 'rlm',
    },
    artist = 'Joey',
    programmer = 'Kekulism',
    requires_type = 'VHS',
}

function voucherInfo.in_pool(self, args)
    return ArrowAPI.loading.consumeable_has_items('Stand')
end

function voucherInfo.locked_loc_vars(self, info_queue, card)
    return { vars = { self.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_vhss_bought or 0} }
end

function voucherInfo.redeem(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = (function()
            G.GAME.vhs_rate = G.GAME.vhs_rate * 2
            return true
        end)
    }))
end

return voucherInfo