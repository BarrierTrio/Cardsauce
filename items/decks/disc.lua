local deckInfo = {
    name = 'DISC Deck',
    config = {
        vouchers = {
            'v_crystal_ball',
        },
    },
    unlocked = false,
    dependencies = {
        config = {
            ['Stands'] = true,
        }
    },
    artist = 'BarrierTrio/Gote'
}

function deckInfo.check_for_unlock(self, args)
    return args.type == 'evolve_stand'
end

function deckInfo.loc_vars(self, info_queue, card)
    return {vars = { localize{type = 'name_text', key = 'v_crystal_ball', set = 'Voucher'} } }
end

function deckInfo.apply(self, back)
    G.GAME.modifiers.csau_unlimited_stands = true
end

deckInfo.quip_filter = function(quip)
    return (quip and quip.csau_streamer and quip.csau_streamer == 'joel')
end

return deckInfo