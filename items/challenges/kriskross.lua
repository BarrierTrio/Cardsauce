local chalInfo = {
    rules = {
        custom = {
            {id = "max_stands", value = 5,}
        },
        modifiers = {
            {id = 'joker_slots', value = 1},
            {id = 'consumable_slots', value = 6}
        }
    },
    vouchers = {
        { id = 'v_csau_foo'}
    },
    unlocked = function(self)
        return G.FUNCS.discovery_check({ mode = 'set_count', set = 'csau_Stand', count = 1, })
    end
}


return chalInfo