local voucherInfo = {
    name = 'Scavenger Hunt',
    cost = 10,
    atlas = 'vouchers',
    pos = {x = 1, y = 0},
    config = {
        rate = 4,
    },
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

function voucherInfo.redeem(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = (function()
            G.GAME.vhs_rate = card.ability.rate
            return true
        end)
    }))
end

return voucherInfo