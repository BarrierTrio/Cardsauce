local voucherInfo = {
    name = 'Plant Appraiser',
    cost = 10,
    atlas = 'arrow_vouchers',
    prefix_config = {atlas = false},
    pos = {x = 0, y = 1},
    requires = {'v_arrow_foo'},
    config = {
        extra = {
            rate = 0.12,
        }
    },
    unlocked = false,
    unlock_condition = {type = 'c_stands_bought', extra = 25},
    origin = {
        category = 'jojo',
        sub_origins = {
            'lion',
        },
        custom_color = 'lion',
    },
    artist = 'BarrierTrio/Gote',
    programmer = 'Kekulism',
    requires_type = 'Stand',
}

function voucherInfo.in_pool(self, args)
    return ArrowAPI.loading.consumeable_has_items('Stand')
end

function voucherInfo.locked_loc_vars(self, info_queue, card)
    return { vars = { self.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_stands_bought or 0} }
end

function voucherInfo.redeem(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = (function()
            G.GAME.evolvedrarity_mod = G.GAME.evolvedrarity_mod + card.ability.extra.rate
            return true
        end)
    }))
end

return voucherInfo