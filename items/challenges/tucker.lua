local chalInfo = {
    rules = {
        custom = {
            {id = "csau_tucker" }
        }
    },
    restrictions = {
        banned_cards = function()
            local banned = {}
            for k, v in pairs(G.P_CENTERS) do
                if ArrowAPI.string.starts_with(k, "j_") then
                    if not ArrowAPI.string.starts_with(k, "j_csau_") then
                        banned[#banned+1] = k
                    end
                end
            end
            return {{id = 'j_csau_banned_jokers', ids = banned}}
        end,
    },
    unlocked = function(self)
        for k, v in pairs(SMODS.Achievements) do
            if k == 'ach_csau_win_vine'  then
                return v.earned
            end
        end
    end
}

return chalInfo