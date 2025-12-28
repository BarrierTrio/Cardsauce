local achInfo = {
    rarity = 3,
    unlock_condition = function(self, args)
        if args.type == 'win_deck' then
            if G.GAME.selected_back.effect.center.key == "b_csau_cbt" then
                return true
            end
        end
    end,
}

return achInfo