local achInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        if args.type == "expire_crudeoil" then
            return true
        end
    end,
}

return achInfo