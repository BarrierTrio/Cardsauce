local voucherInfo = {
    name = 'Foo Fighter',
    cost = 10,
    config = {
        extra = {
            rate = 1,
        }
    },
    part = 'stone',
    csau_dependencies = {
        'enableStands',
    },
    artist = 'BarrierTrio/Gote'
}

function voucherInfo.redeem(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = (function()
            G.GAME.stand_rate = G.GAME.stand_rate + card.ability.extra.rate
            return true
        end)
    }))
end

return voucherInfo