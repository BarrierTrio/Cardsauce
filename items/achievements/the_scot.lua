local achInfo = {
    rarity = 1,
    hidden_text = true,
    unlock_condition = function(self, args)
        if args.type == "the_scot" then
            return true
        end
    end,
}

return achInfo