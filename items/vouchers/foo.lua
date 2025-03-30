local voucherInfo = {
    name = 'Foo Fighters',
    cost = 10,
    config = {
        extra = {
            rate = 1,
        }
    },
    part = 'stone'
}

function voucherInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "stand_incomplete", set = "Other"}
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
end

function voucherInfo.redeem(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = (function()
            G.GAME.stand_rate = G.GAME.stand_rate + card.ability.extra.rate
            return true
        end)
    }))
end

return voucherInfo