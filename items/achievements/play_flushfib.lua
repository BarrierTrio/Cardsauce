local achInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        if args.handname == 'csau_FlushFibonacci' then
            return true
        end
    end,
}

return achInfo