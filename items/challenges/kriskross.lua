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
        return ArrowAPI.game.check_mod_discoveries(Cardsauce.id, 'Stand', 1)
    end
}


return chalInfo