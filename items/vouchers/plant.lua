local voucherInfo = {
    name = 'Plant Appraiser',
    cost = 10,
    config = {
        extra = {
            rate = 0.12,
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
            G.GAME.evolvedrarity_mod = G.GAME.evolvedrarity_mod + card.ability.extra.rate
            return true
        end)
    }))
end

return voucherInfo