local deckInfo = {
    name = 'DISC Deck',
    config = {
        vouchers = {
            'v_crystal_ball',
        },
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {localize{type = 'name_text', key = 'v_crystal_ball', set = 'Voucher'}}}
    end,
    unlocked = false,
    csau_dependencies = {
        'enableStands',
    }
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
end

function deckInfo.apply(self, back)
    G.GAME.csau_unlimited_stands = true
    G.GAME.csau_max_stands = G.GAME.modifiers.max_stands or 1
end

return deckInfo