local deckInfo = {
    name = 'DISC Deck',
    config = {
        vouchers = {
            'v_arrow_foo',
        },
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {localize{type = 'name_text', key = 'v_arrow_foo', set = 'Voucher'}}}
    end,
    unlocked = false,
    origin = {
        category = 'jojo',
        sub_origins = {
            'stone',
        },
        custom_color = 'stone'
    },
    artist = 'BarrierTrio/Gote',
    programmer = 'Kekulism'
}

function deckInfo.check_for_unlock(self, args)
    if args.type == 'evolve_stand' then
        return true
    end
end

function deckInfo.apply(self, back)
    G.GAME.modifiers.unlimited_stands = true
end

return deckInfo
