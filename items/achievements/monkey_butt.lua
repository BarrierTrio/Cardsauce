local achInfo = {
    rarity = 1,
    hidden_text = true,
    unlock_condition = function(self, args)
        if args.type == "monkey_butt" then
            return true
        end
    end,
}

return achInfo