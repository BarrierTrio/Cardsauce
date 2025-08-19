local deckInfo = {
    name = 'DISC Deck',
    config = {
        vouchers = {
            'v_crystal_ball',
        },
    },
    unlocked = false,
    csau_dependencies = {
        'enableStands',
    },
}

function deckInfo.check_for_unlock(self, args)
    if args.type == 'evolve_stand' then
        return true
    end
end

function deckInfo.loc_vars(self, info_queue, card)
    if info_queue then
        info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } }
    end
    return {vars = { localize{type = 'name_text', key = 'v_crystal_ball', set = 'Voucher'} } }
end

function deckInfo.apply(self, back)
    G.GAME.modifiers.csau_unlimited_stands = true
end

deckInfo.quip_filter = function(quip)
    return (quip and quip.csau_streamer and quip.csau_streamer == 'joel')
end

return deckInfo