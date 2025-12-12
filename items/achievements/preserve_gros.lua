local achInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        return args.type == "preserve_gros" and next(SMODS.find_card('j_csau_bunji'))
    end,
}

return achInfo