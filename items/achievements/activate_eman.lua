local achInfo = {
    rarity = 1,
    hidden_text = true,
    unlock_condition = function(self, args)
        if args.type == "activate_eman" then
            return true
        end
    end,
}

return achInfo