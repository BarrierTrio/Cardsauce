local achInfo = {
    rarity = 1,
    unlock_condition = function(self, args)
        if args.handname == 'jojobal_FlushFibonacci' then
            return true
        end
    end,
}

return achInfo